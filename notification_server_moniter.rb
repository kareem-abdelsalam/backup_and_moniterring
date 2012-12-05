require 'yaml'
require 'eventmachine'
require 'rufus/scheduler'
require 'net/http'

server = YAML.load_file('./config/notification_server_moniter.yml')

EM.run do
  scheduler = Rufus::Scheduler::EmScheduler.start_new

  scheduler.every '1h' do
    res = Net::HTTP.get_response(URI.parse(server["notification_server_url"]))
    unless res.code.to_i == 200
      `#{server["command_to_restart"]}`
    end
  end
end