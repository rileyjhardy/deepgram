# frozen_string_literal: true

require 'deepgram/response_handler'

module Deepgram
  # The Base class serves as a foundation for interacting with the Deepgram API.
  # It handles the basic setup and configuration required for making API requests.
  class Base
    include ResponseHandler

    # Initializes a new instance of the Base class.
    #
    # @param options [Hash] A hash of options for configuring the API client.
    # @option options [String] :api_key The Deepgram API key to use for authentication.
    #                                   If not provided, the `DEEPGRAM_API_KEY` environment variable is used.
    # @option options [String] :base_url The base URL for the Deepgram API.
    #                                    If not provided, the `DEEPGRAM_URL` environment variable is used,
    #                                    or defaults to 'https://api.deepgram.com'.
    def initialize(options = {})
      @connection = Faraday.new(url: ENV.fetch('DEEPGRAM_URL', 'https://api.deepgram.com'))
      @connection.headers['Authorization'] = "Token #{ENV.fetch('DEEPGRAM_API_KEY', 'api-key')}"
      @options = options
    end
  end
end
