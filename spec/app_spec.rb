ENV['RACK_ENV'] = 'test'

require './app'
require 'rspec'
require 'rack/test'

describe 'Gif Party Line Bot' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end
