# frozen_string_literal: true

require 'deepgram/response_handler'

module Deepgram
  class Base
    include ResponseHandler

    def initialize(options = {})
      @connection = Faraday.new(url: ENV.fetch('DEEPGRAM_URL', 'https://api.deepgram.com'))
      @connection.headers['Authorization'] = "Token #{ENV.fetch('DEEPGRAM_API_KEY')}"
      @options = options
    end
  end
end
