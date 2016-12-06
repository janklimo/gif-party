require 'sinatra'
require 'line/bot'
require 'httparty'
require './parser'

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        urls = Parser.new(event.message['text']).video_urls

        message = {
          type: 'text',
          text: urls[0]
        }

        client.reply_message(event['replyToken'], message)
      else
        message = {
          type: 'text',
          text: 'Please use text only.'
        }
        client.reply_message(event['replyToken'], message)
      end
    end
  end

  "OK"
end

def client
  @client ||= Line::Bot::Client.new do |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  end
end
