class FreeMemory
	attr_reader :last_checked_at, :interval
	
	def initialize(margin)
		@margin = margin
		@last_checked_at = Time.now.to_i
		@interval = 15
	end

	def run
		command = "cat /proc/meminfo"
		answer = %x`#{command}`
		answer = answer.split(' ')
		free_index = answer.index("MemFree:") 
		@answer = (answer[free_index + 1]).to_f / 1024
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
				"Free memory margin #{@margin} mb has been exceeded"
	end

	def validate
		self.run
		@last_checked_at = Time.now.to_i
		if @answer > @margin.to_i
			return "ok"
		else
			return self.revalidate
		end	
	end
end