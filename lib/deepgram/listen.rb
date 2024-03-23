# frozen_string_literal: true

module Deepgram
  module Listen
    # The Client class is responsible for making API requests to the Deepgram Listen API.
    # It provides methods for transcribing audio files and URLs.
    class Client < Base
      def initialize
        super
        @connection.path_prefix = 'v1/listen'
        @connection.headers['Content-Type'] = 'application/json'
        @connection.headers['Accept'] = 'application/json'
      end

      # Transcribes an audio file using the Deepgram Listen API.
      #
      # @param path [String] The path to the audio file.
      # @param audio_format [String] The format of the audio file (e.g., 'audio/wav').
      # @param kwargs [Hash] Additional optional parameters for the API request.
      #
      # @return [Response] An instance of the Response class containing the API response.
      #
      # @raise [ArgumentError] If the provided file path is invalid.
      def transcribe_file(path:, audio_format: 'audio/wav', **kwargs)
        validate_file_path(path)
        res = @connection.post do |request|
          request.headers['Content-Type'] = audio_format
          request.params.merge!(kwargs)
          request.body = File.binread(path)
        end
        res = handle_response(res)
        Response.new(status: res.status, body: res.body, headers: res.headers)
      end

      # Transcribes an audio file from a URL using the Deepgram Listen API.
      #
      # @param url [String] The URL of the audio file.
      # @param kwargs [Hash] Additional optional parameters for the API request.
      #
      # @return [Response] An instance of the Response class containing the API response.
      #
      # @raise [ArgumentError] If the provided URL is invalid.
      def transcribe_url(url:, **kwargs)
        validate_url(url)
        res = @connection.post do |request|
          request.params.merge!(kwargs)
          request.body = JSON.generate(url: url)
        end
        res = handle_response(res)
        Response.new(status: res.status, body: res.body, headers: res.headers)
      end

      private

      def validate_file_path(path)
        raise ArgumentError, "Invalid file path: #{path}" unless File.exist?(path)
      end

      def validate_url(url)
        raise ArgumentError, "Invalid URL: #{url}" unless url.match?(/\A#{URI::DEFAULT_PARSER.make_regexp}\z/)
      end
    end

    # The Response class encapsulates the response data returned by the Deepgram Listen API.
    # It provides methods for accessing different parts of the response, such as metadata,
    # transcript, words, and confidence.
    class Response
      attr_reader :status, :body, :headers

      def initialize(status:, body:, headers:)
        @status = status
        @body = body
        @headers = headers
      end

      # Returns the metadata associated with the response.
      #
      # @return [Hash] The metadata hash.
      def metadata
        raw['metadata']
      end

      # Returns the transcribed text of the audio.
      #
      # @return [String] The transcribed text.
      def transcript
        raw.dig('results', 'channels', 0, 'alternatives', 0, 'transcript')
      end

      # Returns the individual words detected in the audio, along with their timing information.
      #
      # @return [Array<Hash>] An array of word hashes.
      def words
        raw.dig('results', 'channels', 0, 'alternatives', 0, 'words')
      end

      # Returns the confidence score of the transcription.
      #
      # @return [Float] The confidence score.
      def confidence
        raw.dig('results', 'channels', 0, 'alternatives', 0, 'confidence')
      end

      # Returns the raw response body as a Ruby hash.
      #
      # @return [Hash] The parsed response body.
      def raw
        JSON.parse(@body)
      end
    end
  end
end
