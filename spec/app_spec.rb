ENV['RACK_ENV'] = 'test'

require './app'
require './parser'
require 'rspec'
require 'rack/test'

describe 'Gif Party Line Bot' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

describe Parser do
  describe 'video_urls' do
    before do
      @data = JSON.parse(File.open('./spec/response.json', 'rb').read)
      allow_any_instance_of(Parser).to receive(:parsed_data).and_return @data
    end
    it 'returns the secure Urls' do
      expect(Parser.new('blah').video_urls).to eq [
        "https://img.guggy.com/media/sBPmGNNCAR/animated/0/o/guggy.mp4",
        "https://img.guggy.com/media/sBPmGNNCAR/animated/1/o/guggy.mp4",
        "https://img.guggy.com/media/sBPmGNNCAR/animated/2/o/guggy.mp4",
        "https://img.guggy.com/media/sBPmGNNCAR/animated/3/o/guggy.mp4",
        "https://img.guggy.com/media/sBPmGNNCAR/animated/4/o/guggy.mp4",
        "https://img.guggy.com/media/sBPmGNNCAR/animated/5/o/guggy.mp4"
      ]
    end
  end
end
