class Parser
  def initialize(sentence)
    @sentence = sentence
  end

  def video_urls
    parsed_data['animated'].map do |gif|
      gif['mp4']['original']['secureUrl']
    end
  end

  private

  def data
    @response ||= HTTParty.post(
      'http://text2gif.guggy.com/v2/guggify',
      body: {
        sentence: @sentence
      }.to_json,
      headers: {
        'Content-Type' => 'application/json',
        'apiKey' => ENV['GUGGY_API_KEY']
      }
    )
  end

  def parsed_data
    JSON.parse(data.body)
  end
end
