# frozen_string_literal: true

module Deepgram
  module Listen
    # The Client class within the Listen module extends the Base class
    # to handle operations specific to the Deepgram 'Listen' API endpoint.
    class Client < Base
      # Initializes the Client object for the Deepgram 'Listen' service,
      # setting up the necessary API endpoint and request headers for JSON.
      def initialize
        super
        @connection.path_prefix = 'v1/listen'
        @connection.headers['Content-Type'] = 'application/json'
        @connection.headers['Accept'] = 'application/json'
      end

      # Transcribes audio content from a file.
      #
      # @param path [String] The local file system path to the audio file to be transcribed.
      # @param audio_format [String] The MIME type of the audio file (defaults to 'audio/wav').
      # @param kwargs [Hash] Additional keyword arguments for the request.
      # @return [Deepgram::Listen::Response] The response object containing transcription results.
      def transcribe_file(path:, audio_format: 'audio/wav', **kwargs)
        validate_file_path(path)

        request(:post, **kwargs) do |request|
          request.headers['Content-Type'] = audio_format
          request.body = File.binread(path)
        end
      end

      # Transcribes audio content from a URL.
      #
      # @param url [String] The URL of the audio file to be transcribed.
      # @param kwargs [Hash] Additional keyword arguments for the request.
      # @return [Deepgram::Listen::Response] The response object containing transcription results.
      def transcribe_url(url:, **kwargs)
        validate_url(url)

        request(:post, **kwargs) do |request|
          request.body = JSON.generate(url: url)
        end
      end

      private

      # Validates the file path to ensure the file exists.
      #
      # @param path [String] The file path to validate.
      # @raise [ArgumentError] If the file path does not exist.
      def validate_file_path(path)
        raise ArgumentError, "Invalid file path: #{path}" unless File.exist?(path)
      end

      # Validates the URL to ensure it is properly formatted.
      #
      # @param url [String] The URL to validate.
      # @raise [ArgumentError] If the URL is not properly formatted.
      def validate_url(url)
        raise ArgumentError, "Invalid URL: #{url}" unless url.match?(/\A#{URI::DEFAULT_PARSER.make_regexp}\z/)
      end

      # Overrides the request method from the Base class to wrap the response
      # in a Deepgram::Listen::Response object.
      #
      # @param (see Base#request)
      # @return [Deepgram::Listen::Response] The wrapped response object.
      def request(method, path = nil, **kwargs)
        res = super(method, path, **kwargs)

        Response.new(status: res.status, body: res.body, headers: res.headers)
      end
    end

    # The Response class encapsulates the response from the Deepgram Listen API,
    # providing methods to access various parts of the response data.
    class Response
      attr_reader :status, :body, :headers

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

      # Extracts and returns the metadata from the response data.
      #
      # @return [Hash, nil] The metadata from the response, if present.
      def metadata
        raw['metadata']
      end

      # Extracts and returns the transcript text from the first channel and alternative in the response data.
      #
      # @return [String, nil] The transcript text, if present.
      def transcript
        raw.dig('results', 'channels', 0, 'alternatives', 0, 'transcript')
      end

      # Extracts and returns the words array from the first channel and alternative in the response data.
      #
      # @return [Array, nil] The words array, if present.
      def words
        raw.dig('results', 'channels', 0, 'alternatives', 0, 'words')
      end

      # Extracts and returns the confidence score from the first channel and alternative in the response data.
      #
      # @return [Float, nil] The confidence score, if present.
      def confidence
        raw.dig('results', 'channels', 0, 'alternatives', 0, 'confidence')
      end

      # Parses the response body as JSON and returns the raw data.
      #
      # @return [Hash] The parsed JSON from the response body.
      def raw
        JSON.parse(@body)
      end
    end
  end
end
