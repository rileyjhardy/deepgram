# frozen_string_literal: true

module Deepgram
  class Base
    def initialize(options = {})
      @connection = Faraday.new(url: ENV.fetch('DEEPGRAM_URL', 'https://api.deepgram.com/v1'))
      @connection.headers['Authorization'] = "Token #{ENV.fetch('DEEPGRAM_API_KEY')}"
      @options = options
    end
  end
end
