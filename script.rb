require 'slack-ruby-bot'
require 'yaml'

# Setting ENV variables from application.yml
YAML::load_file(File.join(__dir__, 'application.yml')).each do |key, val|
  ENV[key.to_s] = val.to_s
end

class PongBot < SlackRubyBot::Bot
  command '1' do |client, data, match|
    client.say(text: 'one', channel: data.channel)
  end
  command '2' do |client, data, match|
    client.say(text: 'two', channel: data.channel)
  end
end

PongBot.run
