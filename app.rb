require 'sinatra'
require 'line/bot'

get '/' do
  "Hello, world!"
end

post '/callback' do
  signature = request.env['HTTP_X_LINE_CHANNELSIGNATURE']
  unless client.validate_signature(request.body.read, signature)
    error 400 do 'Bad Request' end
  end

  receive_request = Line::Bot::Receive::Request.new(request.env)

  receive_request.data.each { |message|
    p message.content
    p message.content.address
    case message.content
    when Line::Bot::Message::Text
      process_text(message.from_mid, message.content[:text])
    when Line::Bot::Operation::AddedAsFriend
      client.send_sticker(
        to_mid: message.from_mid,
        stkpkgid: 2,
        stkid: 144,
        stkver: 100
      )
    end
  }

  "OK"
end

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_mid = ENV["LINE_CHANNEL_MID"]
  }
end

def process_text(recipient_id, text)
  user_profile = client.get_user_profile(recipient_id).contacts[0]
  client.send_text(
    to_mid: recipient_id,
    text: "Hello #{user_profile.display_name}! Nice profile picture :)"
  )
  client.send_image(
    to_mid: recipient_id,
    image_url: user_profile.picture_url,
    preview_url: user_profile.picture_url
  )
end
