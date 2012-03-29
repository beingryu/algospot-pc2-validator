require 'test/unit'
Dir.chdir(File.dirname(__FILE__))

require '../ValidatorController'

class TestFileReader < Test::Unit::TestCase
	def test_empty_file
		assert_equal([], FileReader.to_list("data/emptyfile.txt"))
	end

	def test_single_line
		assert_equal(["qwerty abc defghijk;lm.,n;"], FileReader.to_list("data/singleline.txt"))
	end

	def test_multiple_lines
		assert_equal(["a b\n", "c d\n", "e f\n"], FileReader.to_list("data/lines.txt"))
	end
end

class TestValidatorController < Test::Unit::TestCase
	def test_initialize
		assert_nothing_raised() { inst = ValidatorController.new("data/sumit.dat", "data/sumit.ans", "data/sumit.ans") }
	end

	def test_result_yes
		inst = ValidatorController.new("data/sumit.dat", "data/sumit.ans", "data/sumit.ans")
		result = inst.get_result
		assert(result =~ /Yes/)
	end

	def test_result_security_key
		inst = ValidatorController.new("data/sumit.dat", "data/sumit.ans", "data/sumit.ans", "DEADBEEF")
		result = inst.get_result
		assert(result =~ /DEADBEEF/)
	end

	def test_result_no_wa
		inst = ValidatorController.new("data/sumit.dat", "data/sumit.ans", "data/singleline.txt")
		result = inst.get_result
		assert(result =~ /Wrong Answer/)
	end
end

class TestCommandLine < Test::Unit::TestCase
	VOTING_IN = "data\\Voting.in"
	VOTING_ANS = "data\\Voting.out"
	VOTING_L = "data\\Voting_leadingspace.out"
	VOTING_R = "data\\Voting_trailingspace.out"
	VOTING_E = "data\\Voting_emptylines.out"
	VOTING_A = "data\\Voting_whitespace.out"
	VOTING_C = "data\\Voting_case.out"
	VOTING_LREC = "data\\Voting_LREC.out"
	VOTING_WA = "data\\Voting_WA.out"
	FPE_IN = "data\\fpe.out"
	FPE_ANS = "data\\fpe.out"
	FPE_AC = "data\\fpe_ac.out"
	FPE_WA = "data\\fpe_wa.out"
	TEST_PATH = "test.xml"

	def test_yes
		`ruby ..\\main.rb -i #{VOTING_IN} -o #{VOTING_ANS} -a #{VOTING_ANS} -r #{TEST_PATH}`
		result = IO.read(TEST_PATH)
		assert(result =~ /Yes/)
		assert(result =~ /#{TEST_PATH}/)
	end

	def test_L
		`ruby ..\\main.rb -i #{VOTING_IN} -o #{VOTING_L} -a #{VOTING_ANS} -r #{TEST_PATH}`
		result = IO.read(TEST_PATH)
		assert(result =~ /Wrong Answer/)
		assert(result =~ /#{TEST_PATH}/)

		`ruby ..\\main.rb -i #{VOTING_IN} -o #{VOTING_L} -a #{VOTING_ANS} -r #{TEST_PATH} -L`
		result = IO.read(TEST_PATH)
		assert(result =~ /Yes/)
		assert(result =~ /#{TEST_PATH}/)
	end

	def test_R
		`ruby ..\\main.rb -i #{VOTING_IN} -o #{VOTING_R} -a #{VOTING_ANS} -r #{TEST_PATH}`
		result = IO.read(TEST_PATH)
		assert(result =~ /Wrong Answer/)
		assert(result =~ /#{TEST_PATH}/)

		`ruby ..\\main.rb -i #{VOTING_IN} -o #{VOTING_R} -a #{VOTING_ANS} -r #{TEST_PATH} -R`
		result = IO.read(TEST_PATH)
		assert(result =~ /Yes/)
		assert(result =~ /#{TEST_PATH}/)
	end

	def test_E
		`ruby ..\\main.rb -i #{VOTING_IN} -o #{VOTING_E} -a #{VOTING_ANS} -r #{TEST_PATH}`
		result = IO.read(TEST_PATH)
		assert(result =~ /Wrong Answer/)
		assert(result =~ /#{TEST_PATH}/)

		`ruby ..\\main.rb -i #{VOTING_IN} -o #{VOTING_E} -a #{VOTING_ANS} -r #{TEST_PATH} -E`
		result = IO.read(TEST_PATH)
		assert(result =~ /Yes/)
		assert(result =~ /#{TEST_PATH}/)
	end

	def test_A
		`ruby ..\\main.rb -i #{VOTING_IN} -o #{VOTING_A} -a #{VOTING_ANS} -r #{TEST_PATH}`
		result = IO.read(TEST_PATH)
		assert(result =~ /Wrong Answer/)
		assert(result =~ /#{TEST_PATH}/)

		`ruby ..\\main.rb -i #{VOTING_IN} -o #{VOTING_A} -a #{VOTING_ANS} -r #{TEST_PATH} -A`
		result = IO.read(TEST_PATH)
		assert(result =~ /Yes/)
		assert(result =~ /#{TEST_PATH}/)
	end

	def test_C
		`ruby ..\\main.rb -i #{VOTING_IN} -o #{VOTING_C} -a #{VOTING_ANS} -r #{TEST_PATH}`
		result = IO.read(TEST_PATH)
		assert(result =~ /Wrong Answer/)
		assert(result =~ /#{TEST_PATH}/)

		`ruby ..\\main.rb -i #{VOTING_IN} -o #{VOTING_C} -a #{VOTING_ANS} -r #{TEST_PATH} -C`
		result = IO.read(TEST_PATH)
		assert(result =~ /Yes/)
		assert(result =~ /#{TEST_PATH}/)
	end

	def test_LREC
		`ruby ..\\main.rb -i #{VOTING_IN} -o #{VOTING_LREC} -a #{VOTING_ANS} -r #{TEST_PATH}`
		result = IO.read(TEST_PATH)
		assert(result =~ /Wrong Answer/)

		`ruby ..\\main.rb -i #{VOTING_IN} -o #{VOTING_LREC} -a #{VOTING_ANS} -r #{TEST_PATH} -L -R -E -C`
		result = IO.read(TEST_PATH)
		assert(result =~ /Yes/)
	end

	def test_fpe_same
		`ruby ..\\main.rb -v FloatingPointValidator -i #{FPE_IN} -o #{FPE_ANS} -a #{FPE_ANS} -r #{TEST_PATH}`
		result = IO.read(TEST_PATH)
		assert(result =~ /Yes/)
	end

	def test_fpe_ac
		`ruby ..\\main.rb -v FloatingPointValidator -i #{FPE_IN} -o #{FPE_AC} -a #{FPE_ANS} -r #{TEST_PATH}`
		result = IO.read(TEST_PATH)
		assert(result =~ /Yes/)
	end

	def test_fpe_wa
		`ruby ..\\main.rb -v FloatingPointValidator -i #{FPE_IN} -o #{FPE_WA} -a #{FPE_ANS} -r #{TEST_PATH}`
		result = IO.read(TEST_PATH)
		assert(result =~ /Wrong Answer/)
	end
end

class TestValidator < Test::Unit::TestCase
	def test_same_data
		val = ["a b\n", "c d\n", "e f\n"]
		validator = Validator.new([], val, val)
		result = validator.validate
		assert_equal("Yes", result["overcome"])
	end

	def test_wrong_answer_1
		val = ["a b\n", "c d\n", "e f\n"]
		val2 = ["a b\n", "c g\n", "e f\n"]
		validator = Validator.new([], val, val2)
		result = validator.validate
		assert_equal("No - Wrong Answer", result["overcome"])
		assert(result["message"] =~ /#2/)
	end

	def test_wrong_answer_2
		val = []
		val2 = ["a b\n", "c d\n", "e f\n"]
		validator = Validator.new([], val, val2)
		result = validator.validate
		assert_equal("No - Wrong Answer", result["overcome"])
		assert(result["message"] =~ /fewer/)
	end

	def test_wrong_answer_3
		val = ["a b\n", "c d\n", "e f\n"]
		val2 = []
		validator = Validator.new([], val, val2)
		result = validator.validate
		assert_equal("No - Wrong Answer", result["overcome"])
		assert(result["message"] =~ /excessive/)
	end
end

class TestFloatingPointValidator < Test::Unit::TestCase
	def test_same_data
		val = ["a b\n", "c d\n", "e f\n"]
		validator = FloatingPointValidator.new([], val, val)
		result = validator.validate
		assert_equal("Yes", result["overcome"])
	end

	def test_wrong_answer_1
		val = ["a b\n", "c d\n", "e f\n"]
		val2 = ["a b\n", "c g\n", "e f\n"]
		validator = FloatingPointValidator.new([], val, val2)
		result = validator.validate
		assert_equal("No - Wrong Answer", result["overcome"])
		assert(result["message"] =~ /#2/)
	end

	def test_wrong_answer_2
		val = []
		val2 = ["a b\n", "c d\n", "e f\n"]
		validator = FloatingPointValidator.new([], val, val2)
		result = validator.validate
		assert_equal("No - Wrong Answer", result["overcome"])
	end

	def test_wrong_answer_3
		val = ["a b\n", "c d\n", "e f\n"]
		val2 = []
		validator = FloatingPointValidator.new([], val, val2)
		result = validator.validate
		assert_equal("No - Wrong Answer", result["overcome"])
	end

	def test_floating_point_yes
		val = ["1"]
		val2 = ["1.0000000009"]
		validator = FloatingPointValidator.new([], val, val2)
		result = validator.validate
		assert_equal("Yes", result["overcome"])
	end

	def test_floating_point_yes_2
		val = ["Case #1: 1"]
		val2 = ["Case #1: 1.0000000009"]
		validator = FloatingPointValidator.new([], val, val2)
		result = validator.validate
		assert_equal("Yes", result["overcome"])
	end

	def test_floating_point_no
		val = ["Case #1: 1"]
		val2 = ["Case #1: 1.000000011"]
		validator = FloatingPointValidator.new([], val, val2)
		result = validator.validate
		assert_equal("No - Wrong Answer", result["overcome"])
	end

	def test_floating_point_no_string
		val = ["Case #1: 1"]
		val2 = ["Case #1: ERROR"]
		validator = FloatingPointValidator.new([], val, val2)
		result = validator.validate
		assert_equal("No - Wrong Answer", result["overcome"])
	end

	def test_floating_point_no_sign
		val = ["Case #1: 1"]
		val2 = ["Case #1: -1"]
		validator = FloatingPointValidator.new([], val, val2)
		result = validator.validate
		assert_equal("No - Wrong Answer", result["overcome"])
	end

	def test_floating_point_no_size
		val = ["Case #1: 1"]
		val2 = ["Case #1: 1 -1"]
		validator = FloatingPointValidator.new([], val, val2)
		result = validator.validate
		assert_equal("No - Wrong Answer", result["overcome"])
	end

	def test_floating_point_no_line_size
		val = ["Case #1: 1"]
		val2 = ["Case #1: 1", "Case #2: "]
		validator = FloatingPointValidator.new([], val, val2)
		result = validator.validate
		assert_equal("No - Wrong Answer", result["overcome"])
	end

	def test_floating_point_yes_multiple_lines
		val = ["Case #1: 1", "Case #2: 65536.0000000"]
		val2 = ["Case #1: 1.00000000", "Case #2: 65535.999999999"]
		validator = FloatingPointValidator.new([], val, val2)
		result = validator.validate
		assert_equal("Yes", result["overcome"])
	end
end
