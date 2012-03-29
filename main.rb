require 'rubygems'
require 'commandline/optionparser'
current_dir = File.dirname(__FILE__)
require current_dir + "/ValidatorController"

any_error = nil

options = []
options << CommandLine::Option.new(:names => %w(--validator -v),
		:opt_description => "Specifies validator class name (default: Validator)",
		:opt_found => CommandLine::OptionParser::GET_ARG_ARRAY
	       )
options << CommandLine::Option.new(:names => %w(--input -i),
		:opt_description => "Specifies input data file",
		:opt_found => CommandLine::OptionParser::GET_ARGS,
		:opt_not_found => lambda {any_error = true}
	       )
options << CommandLine::Option.new(:names => %w(--output -o),
		:opt_description => "Specifies contestant's output file",
		:opt_found => CommandLine::OptionParser::GET_ARGS,
		:opt_not_found => lambda {any_error = true}
	       )
options << CommandLine::Option.new(:names => %w(--answer -a),
		:opt_description => "Specifies judge's answer file",
		:opt_found => CommandLine::OptionParser::GET_ARGS,
		:opt_not_found => lambda {any_error = true}
	       )
options << CommandLine::Option.new(:names => %w(--result -r),
		:opt_description => "Specifies path to generate xml-formatted file",
		:opt_found => CommandLine::OptionParser::GET_ARGS,
		:opt_not_found => lambda {any_error = true}
	       )
options << CommandLine::Option.new(:flag,
		:names => %w(--left-strip -L),
		:opt_description => "Set to strip any leading whitespaces"
	       )
options << CommandLine::Option.new(:flag,
		:names => %w(--right-strip -R),
		:opt_description => "Set to strip any trailing whitespaces"
	       )
options << CommandLine::Option.new(:flag,
		:names => %w(--ignore-empty-lines -E),
		:opt_description => "Set to ignore all empty lines"
	       )
options << CommandLine::Option.new(:flag,
		:names => %w(--remove-whitespace -A),
		:opt_description => "Set to remove all whitespaces"
	       )
options << CommandLine::Option.new(:flag,
		:names => %w(--ignore-case -C),
		:opt_description => "Set to ignore cases"
	       )
options << CommandLine::Option.new(:flag,
		:names => %w(--help -h),
		:opt_description => "Prints this page",
		:opt_found => lambda {any_error = true}
	       )

option_parser = CommandLine::OptionParser.new(options)

begin
	option_data = option_parser.parse(ARGV)
	throw if any_error
rescue => detail
	puts option_parser.to_s
	exit
end

input_file = option_data["--input"]
output_file = option_data["--output"]
answer_file = option_data["--answer"]
result_file = option_data["--result"]
validator_name = if !option_data["--validator"] then "Validator" else option_data["--validator"][0] end

controller = ValidatorController.new(input_file, output_file, answer_file, result_file)

controller.trim_leading if option_data["--left-strip"]
controller.trim_trailing if option_data["--right-strip"]
controller.remove_empty_lines if option_data["--ignore-empty-lines"]
controller.remove_all_spaces if option_data["--remove-whitespace"]
controller.downcase_all if option_data["--ignore-case"]

result = controller.get_result(validator_name)

File.open(result_file, "w") do |file|
	file.write result
end
