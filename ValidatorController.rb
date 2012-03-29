current_dir = File.dirname(__FILE__)
require current_dir + "/FileReader"
require current_dir + "/Validator"
Dir.glob(File.join(current_dir, "./extras/*.rb")).each {|file| require file} # read all files in extras

class ValidatorFactory
	private :initialize
	def ValidatorFactory.get_validator(input, output, answer, name)
		Object.const_get(name).new(input, output, answer)
	end
end

class ValidatorController
	def initialize(input_path, output_path, answer_path, security_key=nil)
		@input = FileReader.to_list(input_path)
		@output = FileReader.to_list(output_path)
		@answer = FileReader.to_list(answer_path)
		@security_key = security_key
	end

	def trim_leading
		@output.collect! { |x| x.lstrip }
		@answer.collect! { |x| x.lstrip }
	end

	def trim_trailing
		@output.collect! { |x| x.rstrip }
		@answer.collect! { |x| x.rstrip }
	end

	def remove_empty_lines
		@output.delete_if { |x| x.strip == "" }
		@answer.delete_if { |x| x.strip == "" }
	end

	def remove_all_spaces
		@output.collect! { |x| x.gsub(/\s/, '') }
		@answer.collect! { |x| x.gsub(/\s/, '') }
	end

	def downcase_all
		@output.collect! { |x| x.downcase }
		@answer.collect! { |x| x.downcase }
	end

	def get_result(validator_name = "Validator")
		validator = ValidatorFactory.get_validator(@input, @output, @answer, validator_name)
		result = validator.validate
		return ("<?xml version=\"1.0\"?>\n<result outcome=\"%s\" security=\"%s\">%s</result>" % [result["outcome"], @security_key, result["message"]])
	end
end
