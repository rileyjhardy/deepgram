# frozen_string_literal: true

module Deepgram
  module Speak
    # The Client class is responsible for making API requests to the Deepgram Speak API.
    # It provides methods for generating audio from text input, either synchronously or asynchronously.
    class Client < Base
      def initialize
        super
        @connection.path_prefix = 'v1/speak'
        @connection.headers['Content-Type'] = 'application/json'
      end

      # Generates audio from the given text input using the Deepgram Speak API synchronously.
      #
      # @param text [String] The text input to be converted to audio.
      # @param kwargs [Hash] Additional optional parameters for the API request.
      #
      # @return [FileResponse] An instance of the FileResponse class containing the audio file.
      def speak(text:, **kwargs)
        request(:post, **kwargs) do |request|
          request.body = JSON.generate(text: text)
        end
      end

      # Generates audio from the given text input using the Deepgram Speak API asynchronously.
      #
      # @param text [String] The text input to be converted to audio.
      # @param callback_url [String] The URL to be called when the audio is ready.
      # @param kwargs [Hash] Additional optional parameters for the API request.
      #
      # @return [Response] An instance of the Response class containing the API response.
      def speak_async(text:, callback_url:, **kwargs)
        request(:post, callback_url: callback_url, **kwargs) do |request|
          request.body = JSON.generate(text: text)
        end
      end

      private

      def request(method, path = nil, **kwargs)
        res = super(method, path, **kwargs)

        Response.new(status: res.status, body: res.body, headers: res.headers)
      end
    end

    # The Response class encapsulates the response data returned by the Deepgram Speak API
    # for asynchronous requests.
    class Response
      def initialize(status:, body:, headers:)
        @status = status
        @body = body
        @headers = headers
      end

      # Returns the raw response body as a Ruby hash.
      #
      # @return [Hash] The parsed response body.
      def raw
        JSON.parse(@body)
      end

      # Returns the request ID associated with the asynchronous request.
      #
      # @return [String] The request ID.
      def request_id
        raw['request_id']
      end

      def file
        @body
      end
    end
  end
end
