# encoding: utf-8

output = File.readlines(ARGV[0])
answer = File.readlines(ARGV[1])
target = ARGV[2]

result = {}

if output == answer then
  result = { :outcome => 'Yes', :message => 'Correct.' }
else
  if output.size != answer.size
    result = { :outcome => 'No - Wrong Answer',
      :message => "Output contains #{output.size} line(s). Answer contains #{answer.size} line(s)." }
  else
    differ_lines = [output, answer].transpose.map.with_index {|v, idx| v[0] != v[1] && (idx + 1) || nil}.compact
    msg = "#{differ_lines.size} line(s) differ"
    msg << "- first few lines: #{differ_lines.first(5).to_s}"

    result = { :outcome => 'No - Wrong Answer', :message => msg }
  end
end

File.write(target, "<?xml version=\"1.0\"?>\n<result outcome=\"#{result[:outcome]}\" security=\"#{target}\">#{result[:message]}</result>")
