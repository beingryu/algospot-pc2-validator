module Math
	def self.min(a, b)
		a <= b ? a : b
	end
	def self.max(a, b)
		a >= b ? a : b
	end
end

class Validator
	def initialize(input, output, answer)
		@output = output
		@answer = answer
	end

	def validate
		ret = {}

		if @output == @answer then
			ret["outcome"] = "Yes"
			ret["message"] = "No differences found."
		else
			ret["outcome"] = "No - Wrong Answer"

			min_size = Math.min(@output.size, @answer.size)
			mismatch_line = min_size.times do |i|
				if @output[i] != @answer[i] then
				       break i
				end
			end

			if mismatch_line < min_size then
				ret["message"] = ("Mismatch: Line #%d" % (mismatch_line + 1))
			else
				if @output.size < @answer.size then
					ret["message"] = "Output file contains fewer lines than answer file, maybe run-time error?"
				else
					ret["message"] = "Output file contains excessive lines"
				end
			end
		end

		return ret
	end
end
