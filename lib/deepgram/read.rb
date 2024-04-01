# frozen_string_literal: true

require 'deepgram/fixtures'

module Deepgram
  module Read
    # The Client class extends the Base class to handle read operations
    # specific to the Deepgram 'Read' API endpoint.
    class Client < Base
      # Initializes a Client object for the Deepgram 'Read' service.
      # Sets the default language and appropriate headers for JSON requests.
      #
      # @param language [String] The default language to use for analysis (defaults to 'en').
      def initialize(language = 'en')
        super()
        @connection.path_prefix = 'v1/read'
        @connection.params[:language] = language
        @connection.headers['Content-Type'] = 'application/json'
      end

      # Sends a POST request to analyze text using the Deepgram Read API.
      # Returns a Response object containing the analysis results.
      #
      # @param text [String] The text to be analyzed.
      # @param kwargs [Hash] Additional keyword arguments to be sent with the request.
      # @return [Deepgram::Read::Response] The response object containing analysis results.
      def analyze(text:, **kwargs)
        res = request(:post, **kwargs) do |request|
          request.body = JSON.generate(text: text)
        end

        Response.new(status: res.status, body: res.body, headers: res.headers)
      end
    end

    # The Response class encapsulates the response from the Deepgram Read API,
    # providing methods to access various parts of the response data.
    class Response
      # Initializes a new Response object with the given status, body, and headers.
      #
      # @param status [Integer] The HTTP status code of the response.
      # @param body [String] The body of the response, expected to be in JSON format.
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

      # Extracts and returns the metadata from the response data.
      #
      # @return [Hash, nil] The metadata from the response, if present.
      def metadata
        raw['metadata']
      end

      # Extracts and returns the summary text from the response data.
      #
      # @return [String, nil] The summarized text, if present.
      def summary
        raw.dig('results', 'summary', 'text')
      end

      # Extracts and returns the topics segments from the response data.
      #
      # @return [Array, nil] The topics segments, if present.
      def topics
        raw.dig('results', 'topics', 'segments')
      end

      # Extracts and returns the sentiments segments from the response data.
      #
      # @return [Array, nil] The sentiments segments, if present.
      def sentiments
        raw.dig('results', 'sentiments', 'segments')
      end

      # Extracts and returns the intents segments from the response data.
      #
      # @return [Array, nil] The intents segments, if present.
      def intents
        raw.dig('results', 'intents', 'segments')
      end
    end
  end
end
