module FileReader
	def FileReader.to_list(filename)
		ret = []
		IO.foreach(filename) {|line| ret << line}
		ret
	end
end


