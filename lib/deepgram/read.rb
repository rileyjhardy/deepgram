# frozen_string_literal: true

require 'deepgram/fixtures'

module Deepgram
  module Read
    # The Client class is responsible for making API requests to the Deepgram Read API.
    # It provides methods for analyzing text input and retrieving various results,
    # such as summaries, topics, sentiments, and intents.
    class Client < Base
      def initialize(language = 'en')
        super
        @connection.path_prefix = 'v1/read'
        @connection.params[:language] = language
        @connection.headers['Content-Type'] = 'application/json'
      end

      # Analyzes the given text input using the Deepgram Read API.
      #
      # @param text [String] The text input to be analyzed.
      #   current options are: summarize, topics, sentiments, intents.
      # @param kwargs [Hash] Additional optional parameters for the API request.
      #
      # @return [Response] An instance of the Response class containing the API response.
      def analyze(text:, **kwargs)
        res = request(:post, **kwargs) do |request|
          request.body = JSON.generate(text: text)
        end

        Response.new(status: res.status, body: res.body, headers: res.headers)
      end
    end

    # The Response class encapsulates the response data returned by the Deepgram Read API.
    # It provides methods for accessing different parts of the response, such as metadata,
    # summary, topics, sentiments, and intents.
    class Response
      def initialize(status:, body:, headers:)
        @status = status
        @body = body
        @headers = headers
      end

      # Returns the raw response body as a hash.
      #
      # @return [Hash] The parsed response body.
      def raw
        JSON.parse(@body)
      end

      # Returns the metadata associated with the response.
      #
      # @return [Hash] The metadata hash.
      def metadata
        raw['metadata']
      end

      # Returns the summary of the input text.
      #
      # @return [String] The summary text.
      def summary
        raw.dig('results', 'summary', 'text')
      end

      # Returns the detected topics in the input text.
      #
      # @return [Array<Hash>] An array of topic hashes.
      def topics
        raw.dig('results', 'topics', 'segments')
      end

      # Returns the detected sentiments in the input text.
      #
      # @return [Array<Hash>] An array of sentiment hashes.
      def sentiments
        raw.dig('results', 'sentiments', 'segments')
      end

      # Returns the detected intents in the input text.
      #
      # @return [Array<Hash>] An array of intent hashes.
      def intents
        raw.dig('results', 'intents', 'segments')
      end
    end
  end
end
