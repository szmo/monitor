require 'bundler/setup'
Bundler.require
require_relative 'notifiers/mailer'
require_relative 'notifiers/slack'
require_relative 'workers/config_reader'
require_relative 'workers/ping'
require_relative 'workers/free_memory'
require_relative 'workers/free_space'

if __FILE__ == $0
	all_instances = []
	last_notification_at = Time.now.to_i
	conf = ConfigReader.new
	conf.slice_array
	
	conf.jobs.each do |task|
		if task.include? "ping"
			a,address = task.split(' ')
			all_instances.push(Ping.new(address))
		elsif task.include? "free_mem"
			a,margin = task.split(' ')
			all_instances.push(FreeMemory.new(margin))
		elsif task.include? "free_space"
			a,directory,margin = task.split(' ')
			all_instances.push(FreeSpace.new(directory,margin))	
		end
	end

	message = ""
	while true
		all_instances.each do |i|
			if Time.now.to_i - i.last_checked_at > i.interval
				respond = i.validate
				if respond != "ok" && !(message.include? respond)
					message += "#{respond}\n"
				end
			end
		end
		if message.length() > 0 && 
				Time.now.to_i - last_notification_at > 60
			send_email(conf.emails, message)
			send_slack(conf.slack[1], conf.slack[2], message)
			message = ""
			last_notification_at = Time.now.to_i
		end
	end

end
