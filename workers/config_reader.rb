class ConfigReader
	attr_reader :jobs, :emails, :slack

	def initialize
		tasks = File.read('config.txt')
		@arr = tasks.split("\n")
	end

	def slice_array
		@arr.each do |i|
			if (i.include? "email") || (i.include? "slack")
				@jobs, @notifiers = @arr.slice_before(i).to_a
				break
			end
		end
		@emails = @notifiers.slice(0).split(' ')
		@emails.shift
		@slack = @notifiers.slice(1).split(' ')
	end
end