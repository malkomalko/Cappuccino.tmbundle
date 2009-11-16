#!/usr/bin/env ruby -w
# encoding: utf-8

$: << "#{ENV['TM_SUPPORT_PATH']}/lib" if ENV.has_key?('TM_SUPPORT_PATH')
require "exit_codes"
require "ui"
require "web_preview"

unless ENV['CAPP_BUILD']
  puts "CAPP_BUILD wasn't set!"
  TextMate.exit_show_tool_tip
end

DOC_HOME = "#{ENV['CAPP_BUILD']}/Documentation/html"
TM_SCOPE = ENV['TM_SCOPE']
TM_SCOPE_LIST = TM_SCOPE.split(' ')
TM_SCOPE_LAST = TM_SCOPE_LIST.last

TM_CURRENT_WORD = ENV['TM_CURRENT_WORD']
TM_LINE_NUMBER = ENV['TM_LINE_NUMBER'].to_i
TM_LINE_INDEX = ENV['TM_LINE_INDEX'].to_i

unless File.directory?(DOC_HOME)
  puts "Cannot find documentation at #{DOC_HOME}"
  TextMate.exit_show_tool_tip
end

def class_to_page(class_name)
  "#{DOC_HOME}/class#{class_name.gsub(/([A-Z])/){|c| "_#{c.downcase}"}}.html"
end

def class_page_exists?(class_name)
  File.exists?(class_to_page(class_name))
end

def show_class_page(class_name)
  show_page(class_to_page(class_name))
end

def show_page(page)
  puts <<-EOS
<body onload='javascript:window.location.href="tm-file://#{page}"'>
</body>
EOS
  TextMate.exit_show_html
end

@doc_head = nil

def doc_head
  return @doc_head if @doc_head
  head_lines = STDIN.read.split("\n")[0,TM_LINE_NUMBER]
  head_lines[TM_LINE_NUMBER-1] = head_lines[TM_LINE_NUMBER-1][0,TM_LINE_INDEX]
  @doc_head = head_lines.join("\n")
end

def method_call_head
  doc = doc_head
  doc_length = pos = doc.length - 1
  bracket_count = 1
  while bracket_count > 0 && pos >= 0
    case doc[pos]
    when ?[
      bracket_count -= 1
    when ?]
      bracket_count += 1
    end
    pos -= 1
  end
  if bracket_count == 0
    doc[pos+2, doc_length - pos - 1]
  else
    puts "could not find matching [ bracket"
    TextMate.exit_show_tool_tip
  end
end

# caret is inside of a class name
if TM_SCOPE_LAST == 'support.class.cappuccino'
  show_class_page TM_CURRENT_WORD

# caret is inside of a foundation class name
elsif TM_SCOPE_LAST == 'support.variable.cappuccino.foundation'
  TM_CURRENT_WORD == 'CPApp' && show_class_page('CPApplication')

# caret is inside of a objj function call or constant
elsif TM_SCOPE_LAST == 'meta.function-call.js.objj' || TM_SCOPE_LAST == 'support.constant.cappuccino'
  matching_files = `egrep -r '::#{TM_CURRENT_WORD}"' #{DOC_HOME}`.split("\n").map do |line|
    if line =~ /^([^:]+)\:.*member="(\w+)\.j::#{TM_CURRENT_WORD}"\s+ref="(\w+)"/
      [$1, $2, $3]
    else
      nil
    end
  end.compact

  file, base_name, ref = if matching_files.size > 1
    index = TextMate::UI.menu(matching_files.map{|mf| mf[1]})
    TextMate.exit_discard unless index
    matching_files[index]
  elsif matching_files.size == 0
    puts "Cannot find documentation for #{TM_CURRENT_WORD}"
    TextMate.exit_show_tool_tip
  else
    matching_files[0]
  end

  show_page "#{file}##{ref}"

# caret is inside of [ ... ]
elsif TM_SCOPE_LIST.include?('meta.bracketed.js.objj')
  head =  method_call_head
  if head =~ /^[\[\s]*(\w+)/
    class_name = $1
    class_name = 'CPApplication' if class_name == 'CPApp'
  else
    puts "Cannot get class or variable name"
    TextMate.exit_show_tool_tip
  end
  
  if class_page_exists?(class_name)
    file_name = class_to_page(class_name)
    matching_files = `egrep '::#{TM_CURRENT_WORD}[:"]' #{file_name}`.split("\n").map do |line|
      if line =~ /member="(\w+)::([\w\:]+)"\s+ref="(\w+)"/
        [file_name, $1, $2, $3]
      else
        nil
      end
    end.compact
  else
    matching_files = `egrep -r '::#{TM_CURRENT_WORD}[:"]' #{DOC_HOME}`.split("\n").map do |line|
      if line =~ /^([^:]+)\:.*member="(\w+)::([\w\:]+)"\s+ref="(\w+)"/
        [$1, $2, $3, $4]
      else
        nil
      end
    end.compact
  end
  file, class_name, method_name, ref = if matching_files.size > 1
    index = TextMate::UI.menu(matching_files.map{|mf| "#{mf[1]} #{mf[2]}"})
    TextMate.exit_discard unless index
    matching_files[index]
  elsif matching_files.size == 0
    puts "Cannot find documentation for #{TM_CURRENT_WORD}"
    TextMate.exit_show_tool_tip
  else
    matching_files[0]
  end

  show_page "#{file}##{ref}"
end

puts "TM_SCOPE=#{TM_SCOPE}"
puts "TM_CURRENT_WORD=#{TM_CURRENT_WORD}"

TextMate.exit_show_tool_tip
