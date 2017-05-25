class FreeSpace
	attr_reader :last_checked_at, :interval

	def initialize(directory, margin)
		@directory = directory
		@margin = margin
		@last_checked_at = Time.now.to_i
		@interval = 30
	end

	def run
		command = "df -km #{@directory}"
		answer = %x`#{command}`
		if answer.length > 0
			answer = answer.split("\n")
			answer = answer[1].split
			@answer = answer[3].to_f
		else
			@answer ="#{@directory} There is no such file or directory"
		end
	end

	def revalidate
		output = ""
		3.times do |i|
			self.run
			if @answer > @margin.to_i
				output += "ok"
			else
				output += "error"
			end
		end
		return (output.include? "ok") ? 
				"ok" : 
				"Free space margin #{@margin} mb in #{@directory} has been exceeded"
	end

	def validate
		self.run
		@last_checked_at = Time.now.to_i
		if @answer.is_a? String
			return @answer
		end 
		if @answer > @margin.to_i
			return "ok"
		else
			return self.revalidate
		end	
	end
end