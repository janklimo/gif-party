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

  describe '#process_text' do
    context 'hello' do
      before do
        @double = double('client', send_text: true)
        allow(Line::Bot::Client).to receive(:new).and_return @double
      end
      it 'responds with username' do
        process_text(1, 'a')
        expect(@double).to have_received(:send_text)
          .with(to_mid: 1, text: 'a')
      end
    end
  end
end
