ENV['RACK_ENV'] = 'test'

require './app'
require 'rspec'
require 'rack/test'

describe 'Tripler Line Bot' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET' do
    it "says hello" do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to eq 'Hello, world!'
    end
  end
end
