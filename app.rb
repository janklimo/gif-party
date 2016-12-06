require 'sinatra'
require 'line/bot'
require 'httparty'

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
        response = HTTParty.post(
          'http://text2gif.guggy.com/v2/guggify',
          body: {
            sentence: event.message['text']
          }.to_json,
          headers: {
            'Content-Type' => 'application/json',
            'apiKey' => ENV['GUGGY_API_KEY']
          }
        )

        gif_data = JSON.parse(response.body)
        puts '======================='
        p gif_data

        gifs = gif_data['animated'].map do |gif|
          gif['mp4']['original']['secureUrl']
        end
        client.reply_message(event['replyToken'], gifs[0])
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
