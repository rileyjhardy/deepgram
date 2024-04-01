# frozen_string_literal: true

require 'deepgram/response_handler'

module Deepgram
  class Base
    include ResponseHandler

    attr_reader :connection

    def initialize(options = {})
      @connection = Faraday.new(url: ENV.fetch('DEEPGRAM_URL', 'https://api.deepgram.com'))
      @connection.headers['Authorization'] = "Token #{ENV.fetch('DEEPGRAM_API_KEY', 'api-key')}"
      @options = options
    end

    def request(method, path = nil, **kwargs)
      res = @connection.send(method, path, **kwargs) do |request|
        yield(request) if block_given?
        request.params.merge!(kwargs)
      end

      handle_response(res)
    end
  end
end
