# encoding: utf-8

require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.on("-l", "Strip left(leading) whitespaces") { |v| options[:left] = v }
  opts.on("-r", "Strip right(trailing) whitespaces") { |v| options[:right] = v }
  opts.on("-e", "Strip all whitespaces") { |v| options[:all] = v }
  opts.on("-z", "Strip last empty line") { |v| options[:last] = v }
  opts.on("-e", "Strip empty lines") { |v| options[:empty] = v }
  opts.on("-i", "Ignore cases") { |v| options[:ignore] = v }
  opts.on("-f file0,file1,file2", Array, "Files to process") { |v| options[:files] = v }
end.parse!

options[:files].each do |fn|
  arr = File.readlines(fn)

  arr.map!(&:chomp)
  arr.pop if options[:last] && arr[-1].empty?
  arr.map!(&:lstrip) if options[:left]
  arr.map!(&:rstrip) if options[:right]
  arr.map! {|x| x.gsub(/\s/, '')} if options[:all]
  arr.delete_if(&:empty?) if options[:empty]
  arr.map!(&:downcase) if options[:ignore]
  
  path = File.dirname(fn) + File::SEPARATOR + 'x.' + File.basename(fn)
  File.binwrite(path, arr.join("\n"))
end
