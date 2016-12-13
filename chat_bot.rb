require 'slack-ruby-client'
require 'yaml'


# Setting ENV variables from application.yml
YAML::load_file(File.join(__dir__, 'application.yml')).each do |key, val|
  ENV[key.to_s] = val.to_s
end

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

client = Slack::RealTime::Client.new

client.on :hello do
  puts 'Successfully connected.'
end

client.on :message do |data|
  case data['text']
  when 'bot hi' then
    client.message channel: data['channel'], text: "Hi <@#{data['user']}>!"
  when /^bot/ then
    client.message channel: data['channel'], text: "Sorry <@#{data['user']}>, what?"
  end
end

client.start!
