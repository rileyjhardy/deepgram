# frozen_string_literal: true

require 'deepgram/response_handler'

module Deepgram
  # The Base class initializes the Faraday connection to interact with the Deepgram API
  # and provides a generic request method for its subclasses.
  class Base
    include ResponseHandler

    # Initializes a Faraday connection to the Deepgram API.
    # The API endpoint and authorization token are set via environment variables,
    # with defaults provided.
    #
    # @param options [Hash] Optional parameters for future extensions.
    def initialize(options = {})
      @connection = Faraday.new(url: ENV.fetch('DEEPGRAM_URL', 'https://api.deepgram.com'))
      @connection.headers['Authorization'] = "Token #{ENV.fetch('DEEPGRAM_API_KEY', 'api-key')}"
      @options = options
    end

    # Sends an HTTP request to the specified path using the initialized Faraday connection.
    # This method is designed to be flexible, allowing any HTTP method to be used.
    #
    # @param method [Symbol] The HTTP method to use (:get, :post, etc.).
    # @param path [String, nil] The path to append to the base API URL (optional).
    # @param kwargs [Hash] Additional keyword arguments to include in the request.
    # @yieldparam request [Faraday::Request] The request object, allowing for further customization.
    # @return [Faraday::Response] The response from the Faraday connection.
    def request(method, path = nil, **kwargs)
      res = @connection.send(method, path, **kwargs) do |request|
        yield(request) if block_given?
        request.params.merge!(kwargs)
      end

      handle_response(res)
    end

    private

    # Accessor for the Faraday connection instance
    # @return [Faraday::Connection] The Faraday connection used to interact with the API.
    attr_reader :connection
  end
end
