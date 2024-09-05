require 'sinatra'   # gem 'sinatra'
require 'line/bot'  # gem 'line-bot-api'
require 'mqtt'
require 'rubygems'
require 'net/http' #net/https does not have to be required anymore
require 'json'
require 'uri'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = "U632d0e50a728dccdc03cb3d8d45eb170"
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

post '/callback' do
  request.body.rewind
  body = request.body.read
  json_body = JSON.parse(body)

  if json_body['ESP']
    message = {
        type: 'text',
        text: json_body['ESP']
      }
      #client.push_message("C13fa3b9ab7ddd59f4175f86712153d03", message)
      #client.push_message("C9c7c2c3dbf0d0b116c86bc6af8e6c73e", message)    #this
      MQTT::Client.connect('broker.emqx.io') do |c|
            "test"
            c.publish('fr3oiltemp', 'testfromspace')
      end
      "test2222"
      puts 'your debug message'
  else
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          #client.reply_message(event['replyToken'], message)
          #client.push_message("U97f1978ea01a7f94867501b8a66b6038", message)
          #client
         # Publish example
          MQTT::Client.connect('broker.emqx.io') do |c|
            a = c.publish('fr3oiltemp', event.message['text'])
          end
          puts 'your debug message'
          #uri = URI('https://oil_2_flask-1-h5379095.deta.app/mqtt')
          #headers = { 'Content-Type': 'application/json' }
          #body = { topic: 'fr3oiltemp', msg: event.message['text'] }
          #response = Net::HTTP.post(uri, body.to_json, headers)
        end
      end
    end
  end
  #signature = request.env['HTTP_X_LINE_SIGNATURE']
  #unless client.validate_signature(body, signature)
  #  halt 400, {'Content-Type' => 'text/plain'}, 'Bad Request'
  #end
  
  #events = client.parse_events_from(body)
  "OK"
  "123456789"
end
