def send_slack(token, room_name, msg)
	host = %x`hostname`
	header = "From #{host}"
	Slack.configure do |config|
  		config.token = token 
	end

	client = Slack::Web::Client.new

	client.chat_postMessage(channel: room_name, 
							text: "#{header} #{msg}", 
							as_user: true)
end