def send_email(email_list, msg_body)
	hostname = %x`hostname`
	msg_subject = "Error message from #{hostname}"
	options = { :address              => "smtp.gmail.com",
            	:port                 => 587,
            	:user_name            => 'YOUR_EMAIL_HEREatGMAIL.COM',
            	:password             => 'PASSWORD',
            	:authentication       => 'plain',
            	:enable_starttls_auto => true  }

    Mail.defaults do
    	delivery_method :smtp, options
    end

    email_list.each do |e|
		mail = Mail.new do
			from    'monitor@monitor.pl'
			to      e
			subject msg_subject
			body    msg_body
		end
		mail.deliver
	end
end