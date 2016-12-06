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
  before do
    @data = JSON.parse(File.open('./spec/response.json', 'rb').read)
    allow_any_instance_of(Parser).to receive(:parsed_data).and_return @data
  end
  describe 'video_urls' do
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
  describe 'preview_urls' do
    it 'returns the secure Urls' do
      expect(Parser.new('blah').preview_urls).to eq [
        "https://guggyrepository.guggy.com/DwDd9A0ktH7WUR9nZHvx.jpg",
        "https://guggyrepository.guggy.com/t14THzWwZiDrza1Tifxp.jpg",
        "https://guggyrepository.guggy.com/tPGiDjcxdeTj9j9LqQ0Q.jpg",
        "https://guggyrepository.guggy.com/DcgHfuoyQnvgcfi0FBua.jpg",
        "https://guggyrepository.guggy.com/hhDgqxtchbmN7Cmclhte.jpg",
        "https://guggyrepository.guggy.com/Zmf9ZdBFKCxkCl4PCp5d.jpg"
      ]
    end
  end
end
