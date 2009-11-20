bundle_path  = ENV['TM_BUNDLE_SUPPORT']
support_path = ENV['TM_SUPPORT_PATH']
require support_path + '/lib/osx/plist'
require support_path + '/lib/ui.rb'
require bundle_path  + '/lib/dialog1.rb'

class Autocomplete
  attr_reader :empty, :brackets, :classes, :file_name, :previous_line, :choices
  
  def initialize(current_word)
    case current_word
    when /\[\]/ : current_word = current_word.gsub(' ','').gsub(';','')
    when /^\s+$/ : current_word = nil
    when nil : current_word = nil
    else current_word = current_word.gsub(' ','').gsub('[','').gsub(']','').gsub(';','')
    end
    
    files = Dir["#{ENV['TM_DIRECTORY']}/**/*.j"] + Dir["#{ENV['TM_BUNDLE_SUPPORT']}/source/**/*.j"]
    data = $stdin.read
    
    @empty, @brackets = false
    @classes = []
    
    previous_line = ENV['TM_LINE_NUMBER'].to_i - 2
    @previous_line = previous_line
    files.each { |file| @classes << file.split('/').last[0..-3] }
    classes_for_regex = @classes.join('|')
    
    setup(current_word, classes_for_regex, data)
    nib = ENV['TM_BUNDLE_SUPPORT'] + '/nib/Completion.nib'
    
    if !(@brackets == true || current_word == '')
      if current_word == nil
        if @previous_line.gsub(' ','').size > 0
          setup(@previous_line.gsub('[','').gsub(']','').gsub(' ',''), classes_for_regex, data)
          response = show_dialog(nib,@choices)
          if !response.nil?
            response_for_snippet = response.gsub(/(\(\w+\)\w+)/).each_with_index do |result, i|
              result = "${#{i+1}:#{result}}"
            end
            print "#{e_sn(@previous_line)}#{response_for_snippet}];\n$0"
          end
        end
      elsif !@choices.nil?
        response = show_dialog(nib,@choices)
        if !response.nil?
          response_for_snippet = response.gsub(/(\(\w+\)\w+)/).each_with_index do |result, i|
            result = "${#{i+1}:#{result}}"
          end
        end
        print response_for_snippet unless response_for_snippet.nil?
      end
    end
  end
  
  def setup(current_word, classes_for_regex, data)
    if @classes.include?(current_word)
      custom = Dir["#{ENV['TM_DIRECTORY']}/**/*.j"].find {|a| a.include?(current_word+'.j') }.nil? ? false : true
      @file_name = custom ? "#{ENV['TM_DIRECTORY']}/#{current_word}.j" : "#{ENV['TM_BUNDLE_SUPPORT']}/source/#{current_word}.j"
      create_choices(@file_name)
    else
      case current_word
      when '[]' :
        @brackets = true
      when nil :
        @empty = true
        data.each_with_index { |l,i| @previous_line = l.scan(/^\s+(\[\w+ )/).first.to_s if i == previous_line }
      when '' :
        # do nothing for now
      else
        lines_matching_regex = []
        data.each_line { |line| lines_matching_regex << line if line =~ (/\s+(#{current_word}\s+=)|(#{current_word}=)/) }
        
        if lines_matching_regex.size == 1
          current_word = lines_matching_regex.first.scan(/(#{classes_for_regex})/).to_s
          support_files = Dir["#{ENV['TM_BUNDLE_SUPPORT']}/source/**/*.j"]
          custom = support_files.find {|a| a.include?(current_word+'.j') }.nil? ? true : false
          @file_name = custom ? "#{ENV['TM_DIRECTORY']}/#{current_word}.j" : "#{ENV['TM_BUNDLE_SUPPORT']}/source/#{current_word}.j"
          create_choices(@file_name, 'instance')
        elsif lines_matching_regex.size > 1
          TextMate::UI.alert(:warning, "Duplicate variable", "Please make sure you use unique variable names", 'Ok')
        end
      end
    end
  end
  
  def show_dialog(nib,choices)
    TextMate::UI.dialog1(:nib => nib, :parameters => choices,
      :options => {:center => true, :modal => true}) do |results|
      if results['result']
        results['result']['returnArgument']
      else
        # do nothing
      end
    end
  end
  
  def create_choices(file_name, type='klass')
    begin
      lines_matching_regex = []
      @choices ||= {}
      @choices['completionArray'] = []
      data = File.new(file_name).read
      m = data.scan(/.*?(@implementation.*?\@end)/m)
      if m.length > 0
        for i in 0...m.length
          line = m[i][0]
          m2 = line.scan(/.*?@implementation\s*(\w*).*?/m)
          if !m2.nil? && !m2[0].nil?
            className = m2[0][0].strip()
            if className == file_name.split('/').last[0..-3]
              lines_matching_regex << line.scan(/^#{type == 'klass' ? '\+' : '-'}\s*([a-zA-Z\(\)\s:_]*).*?/m)
              add_parent_methods(line, type)
            end
          end
        end
        
        add_methods_to_hash(lines_matching_regex, className)
        clean_array = @choices['completionArray'].reverse.inject({}) do |hash,item|
           hash[item['display']]||=item
           hash 
        end.values
        @choices = {'completionArray' => clean_array.sort_by {|c| c['display'].to_s.downcase } }
      end
    rescue => err
      @choices = nil
    end
  end
  
  def add_parent_methods(line, type)
    lines_matching_regex = []
    match = line.scan(/.*?@implementation.*?:\s*(\w+).*/m)
    if !match.nil? && !match[0].nil?
      parent_class = match[0][0].strip()
      if @classes.include?(parent_class)
        support_files = Dir["#{ENV['TM_BUNDLE_SUPPORT']}/source/**/*.j"]
        custom = support_files.find {|a| a.include?(parent_class+'.j') }.nil? ? true : false
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
                lines_matching_regex << l.scan(/^#{type == 'klass' ? '\+' : '-'}\s*([a-zA-Z\(\)\s:_]*).*?/m)
                add_parent_methods(l, type)
              end
            end
          end
          add_methods_to_hash(lines_matching_regex, className)
        end
      end
    end
  end
  
  def add_methods_to_hash(lines, className)
    lines.flatten!.each do |line|
      @choices['completionArray'] << {
        'display' => line.gsub(/\(\w*\)/, '').gsub(/\n+/,'').gsub(/\s{2,}/,' '),
        'methodDef' => line.gsub(/\n+/,'').gsub(/\s{2,}/,' ').gsub(/^\(\w+\)/,''),
        'class' => className,
        'docs' => "From Class: #{className}\n\n" + "Full method definition: #{line.gsub(/\n+/,'').gsub(/\s{2,}/,' ')}"
      }
    end
  end
end