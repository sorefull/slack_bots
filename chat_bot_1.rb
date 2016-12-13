require 'slack-ruby-client'
require 'yaml'


# Setting ENV variables from application.yml
YAML::load_file(File.join(__dir__, 'application.yml')).each do |key, val|
  ENV[key.to_s] = val.to_s
end

staff = {}

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

client = Slack::RealTime::Client.new

client.on :hello do
  puts 'Successfully connected.'
end

client.on :message do |data|
  case data['text']
  when /start/
    text = "start | here | gone | knok | team"
    client.message channel: data['channel'], text: text

  when /here/
    client.message channel: data['channel'], text: "Welcome <@#{data['user']}>!"
    staff[data['user']] = { status: 'on place', time: Time.now.strftime('%b %d %y. %H:%M') }

  when /gone/
    client.message channel: data['channel'], text: "Have anice day <@#{data['user']}>!"
    staff[data['user']] = { status: 'gone', time: Time.now.strftime('%b %d %y. %H:%M') }

  when /knok/
    msg = "Here is your teammates on place \n"
    staff.each do |username, user_hash|
      msg << "<@#{username}> time: #{user_hash[:time]} \n" if user_hash[:status] == 'on place'
    end
    msg = "No one here :(" if msg.length <= 33
    client.message channel: data['channel'], text: msg

  when /team/
    msg = "Here is your teammates: \n"
    staff.each do |username, user_hash|
      msg << "<@#{username}> #{user_hash[:status]} since #{user_hash[:time]} \n"
    end
    msg = "You are the one in your team ;(" if msg.length <= 25
    client.message channel: data['channel'], text: msg

  else
    client.message channel: data['channel'], text: "Sorry <@#{data['user']}>, what?"

  end
end

client.start!
