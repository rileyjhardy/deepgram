# frozen_string_literal: true

module Deepgram
  class Base
    def initialize(options = {})
      @connection = Faraday.new(url: 'https://api.deepgram.com')
      @connection.headers['Authorization'] = "Token #{ENV.fetch('DEEPGRAM_ACCESS_TOKEN')}"
      @options = options
    end
  end
end
