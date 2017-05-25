class Ping
	attr_reader :last_checked_at, :interval

	def initialize(address)
		@address = address
		@last_checked_at = Time.now.to_i
		@interval = 5
	end

	def run
		command = "ping #{@address} -c 1"
		@answer = %x`#{command}`
	end

	def revalidate
		output = ""
		3.times do |i|
			self.run
			if @answer.include? "1 received"
				output += "ok"
			else
				output += "error"
			end
		end
		return (output.include? "ok") ? "ok" : "Network problems!"
	end

	def validate
		self.run
		@last_checked_at = Time.now.to_i
		if @answer.include? "1 received"
			return "ok"
		else
			return self.revalidate
		end	
	end
end