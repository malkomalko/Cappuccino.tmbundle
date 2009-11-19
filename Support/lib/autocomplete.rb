support_path = ENV['TM_SUPPORT_PATH']
require support_path + '/lib/ui.rb'

# TextMate::UI.alert(:warning, "Debug", "#{var}", 'Ok')
class Autocomplete
  attr_reader :empty, :brackets, :classes, :file_name, :previous_line, :lines_matching_regex
  
  def initialize(current_word)
    case current_word
    when /\[\]/ : current_word = current_word.gsub(' ','')
    when /^\s+$/ : current_word = nil
    else current_word = current_word.gsub(' ','').gsub('[','').gsub(']','')
    end
    
    files = Dir["#{ENV['TM_DIRECTORY']}/**/*.j"] + Dir["#{ENV['TM_BUNDLE_SUPPORT']}/source/**/*.j"]
    
    @empty, @brackets = false
    @classes = []
    @lines_matching_regex = []
    
    previous_line = ENV['TM_LINE_NUMBER'].to_i - 2
    
    files.each { |file| @classes << file.split('/').last[0..-3] }
    classes_for_regex = @classes.join('|')
    
    if @classes.include?(current_word)
      custom = Dir["#{ENV['TM_DIRECTORY']}/**/*.j"].find {|a| a.include?(current_word+'.j') }.nil? ? false : true
      @file_name = custom ? "#{ENV['TM_DIRECTORY']}/#{current_word}.j" : "#{ENV['TM_BUNDLE_SUPPORT']}/source/#{current_word}.j"
      choices = create_choices(@file_name)
    else
      data = $stdin.read
      case current_word
      when '[]' :
        @brackets = true
      when nil :
        @empty = true
        data.each_with_index { |l,i| @previous_line = l.scan(/^\s+(\[\w+ )/).first.to_s if i == previous_line }
      else
        lines_matching_regex = []
        data.each_line { |line| lines_matching_regex << line if line =~ (/(#{current_word}\s+=)|(#{current_word}=)/) }
        
        if lines_matching_regex.size == 1
          current_word = lines_matching_regex.first.scan(/(#{classes_for_regex})/).to_s
          custom = Dir["#{ENV['TM_DIRECTORY']}/**/*.j"].find {|a| a.include?(current_word+'.j') }.nil? ? false : true
          @file_name = custom ? "#{ENV['TM_DIRECTORY']}/#{current_word}.j" : "#{ENV['TM_BUNDLE_SUPPORT']}/source/#{current_word}.j"
          choices = create_choices(@file_name, 'instance')
        elsif lines_matching_regex.size > 1
          TextMate::UI.alert(:warning, "Duplicate variable", "Please make sure you use unique variable names", 'Ok')
        end
      end
    end
    
    options = { :extra_chars => '_():', :case_insensitive => false }
    TextMate::UI.complete(choices, options)
  end
  
  def create_choices(file_name, type='klass')
    data = File.new(file_name).read
    
    m = data.scan(/.*?(@implementation.*?\@end)/m)
    if m.length > 0
      for i in 0...m.length
        line = m[i][0]
        m2 = line.scan(/.*?@implementation\s*(\w*).*?/m)
        if !m2.nil? && !m2[0].nil?
          className = m2[0][0].strip()
          if className == file_name.split('/').last[0..-3]
            @lines_matching_regex << line.scan(/^#{type == 'klass' ? '\+' : '-'}\s*([a-zA-Z\(\)\s:_]*).*?/m)
            add_parent_methods(line, type)
          end
        end
      end
      
      choices = []
      @lines_matching_regex.flatten!.each do |line|
        choices << {
          'display' => line.gsub(/\(\w*\)/, '').gsub(' ','').gsub(/\n+/,''),
          'match' => line.gsub(/\(\w*\)/, '').gsub(' ','').gsub(/\n+/,'')
        }
      end
      choices.uniq.sort_by {|c| c['display'].downcase }
    end
  end
  
  def add_parent_methods(line, type)
    match = line.scan(/.*?@implementation.*?:\s*(\w+).*/m)
    if !match.nil? && !match[0].nil?
      parent_class = match[0][0].strip()
      if @classes.include?(parent_class)
        custom = Dir["#{ENV['TM_DIRECTORY']}/**/*.j"].find {|a| a.include?(parent_class+'.j') }.nil? ? false : true
        file = custom ? "#{ENV['TM_DIRECTORY']}/#{parent_class}.j" : "#{ENV['TM_BUNDLE_SUPPORT']}/source/#{parent_class}.j"
        data = File.new(file).read
        m = data.scan(/.*?(@implementation.*?\@end)/m)
        if m.length > 0
          for i in 0...m.length
            l = m[i][0]
            m2 = l.scan(/.*?@implementation\s*(\w*).*?/m)
            if !m2.nil? && !m2[0].nil?
              className = m2[0][0].strip()
              if className == parent_class
                @lines_matching_regex << l.scan(/^#{type == 'klass' ? '\+' : '-'}\s*([a-zA-Z\(\)\s:_]*).*?/m)
                add_parent_methods(l, type)
              end
            end
          end
        end
      end
    end
  end
end