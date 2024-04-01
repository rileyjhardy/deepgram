# frozen_string_literal: true

module Deepgram
  module Speak
    # The Client class within the Speak module extends the Base class
    # to handle operations specific to the Deepgram 'Speak' API endpoint.
    class Client < Base
      # Initializes the Client object for the Deepgram 'Speak' service,
      # setting up the necessary API endpoint and request headers for JSON.
      def initialize
        super
        @connection.path_prefix = 'v1/speak'
        @connection.headers['Content-Type'] = 'application/json'
      end

      # Sends a synchronous request to convert text to speech.
      #
      # @param text [String] The text to be converted to speech.
      # @param kwargs [Hash] Additional keyword arguments for the request.
      # @return [Deepgram::Speak::Response] The response object containing the speech file.
      def speak(text:, **kwargs)
        request(:post, **kwargs) do |request|
          request.body = JSON.generate(text: text)
        end
      end

      # Sends an asynchronous request to convert text to speech, with the results
      # sent to a specified callback URL.
      #
      # @param text [String] The text to be converted to speech.
      # @param callback_url [String] The URL to which the response will be sent upon completion.
      # @param kwargs [Hash] Additional keyword arguments for the request.
      # @return [Deepgram::Speak::Response] The response object containing the speech file or request details.
      def speak_async(text:, callback_url:, **kwargs)
        request(:post, callback_url: callback_url, **kwargs) do |request|
          request.body = JSON.generate(text: text)
        end
      end

      private

      # Overrides the request method from the Base class to wrap the response
      # in a Deepgram::Speak::Response object.
      #
      # @param (see Base#request)
      # @return [Deepgram::Speak::Response] The wrapped response object.
      def request(method, path = nil, **kwargs)
        res = super(method, path, **kwargs)

        Response.new(status: res.status, body: res.body, headers: res.headers)
      end
    end

    # The Response class encapsulates the response from the Deepgram Speak API,
    # providing methods to access various parts of the response data.
    class Response
      # Initializes a new Response object with the given status, body, and headers.
      #
      # @param status [Integer] The HTTP status code of the response.
      # @param body [String] The body of the response, expected to contain the speech file or request details.
      # @param headers [Hash] The HTTP headers of the response.
      def initialize(status:, body:, headers:)
        @status = status
        @body = body
        @headers = headers
      end

      # Parses the response body as JSON and returns the raw data.
      #
      # @return [Hash] The parsed JSON from the response body.
      def raw
        JSON.parse(@body)
      end

      # Extracts and returns the request ID from the response data.
      #
      # @return [String, nil] The request ID, if present.
      def request_id
        raw['request_id']
      end

      # Returns the body of the response, which contains the speech file in asynchronous requests.
      #
      # @return [String] The body of the response.
      def file
        @body
      end
    end
  end
end
