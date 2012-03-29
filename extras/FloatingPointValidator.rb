####  RUBY  CODE  FOLLOWS  ####

# Conversion from a String to Numbers should raise an exception if the string has
# an improper format. Strangely enough, Ruby's standard conversion functions do not
# provide for any kind of error handling and return number '0' on failure.
# Therefore, in Ruby one cannot possibly distinguish between these two cases:
#       "0".to_i             # -> 0
#       "not-a-number".to_i  # -> 0

# The following code augments standard conversion functions String#to_i and
# String#to_f with the error handling code so that an attempt to convert a
# string not suited for numeric conversion will raise NumericError exception.

class NumericError < RuntimeError
end

class String
  alias __std__to_i to_i   if ! method_defined? :__std__to_i
  alias __std__to_f to_f   if ! method_defined? :__std__to_f
  alias __std__hex  hex    if ! method_defined? :__std__hex
  alias __std__oct  oct    if ! method_defined? :__std__oct
  
  def to_i()
    case self 
    when /^[-+]?0\d$/         then  __std__oct
    when /^[-+]?0x[a-f\d]$/i  then  __std__hex
    when /^[-+]?\d$/          then  __std__to_i
    else raise NumericError, "Cannot convert string to Integer!"
    end
  end

  def to_f()
    case self
    when /^[-+]?\d*\.?\d+$/  then  __std__to_f
    else raise NumericError, "Cannot convert string to Float!"
    end
  end
end

class FloatingPointValidator < Validator
	EPSILON = 1e-7
	def validate
		ret = {}

		if @output.size != @answer.size
			ret["outcome"] = "No - Wrong Answer"
			ret["message"] = "Number of lines are mismatching"
		else
			break_line = @output.size.times do |i|
				out_arr = @output[i].split(/\s/)
				ans_arr = @answer[i].split(/\s/)

				if out_arr.size != ans_arr.size
					break i
				end

				ok_flag = true

				out_arr.size.times do |j|
					begin
						out_val = out_arr[j].to_f
						ans_val = ans_arr[j].to_f
						if (out_val - ans_val).abs > EPSILON * Math.max(1, ans_val.abs) then
							ok_flag = false
							break
						end
					rescue => ex
						if out_arr[j] != ans_arr[j] then
							ok_flag = false
							break
						end
					end
				end

				if !ok_flag
					break i
				end
			end

			if break_line < @output.size then
				ret["outcome"] = "No - Wrong Answer"
				ret["message"] = ("Mismatch: Line #%d" % (break_line + 1))
			else
				ret["outcome"] = "Yes"
				ret["message"] = "No differences found."
			end
		end

		return ret
	end
end
