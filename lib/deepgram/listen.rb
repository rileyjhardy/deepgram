# frozen_string_literal: true

module Deepgram
  module Listen
    class Client < Base
      def initialize
        super
        @connection.path_prefix = 'v1/listen'
        @connection.headers['Content-Type'] = 'application/json'
        @connection.headers['Accept'] = 'application/json'
      end

      def transcribe_file(path:, audio_format: 'audio/wav', **kwargs)
        validate_file_path(path)

        request(:post, **kwargs) do |request|
          request.headers['Content-Type'] = audio_format
          request.body = File.binread(path)
        end
      end

      def transcribe_url(url:, **kwargs)
        validate_url(url)

        request(:post, **kwargs) do |request|
          request.body = JSON.generate(url: url)
        end
      end

      private

      def validate_file_path(path)
        raise ArgumentError, "Invalid file path: #{path}" unless File.exist?(path)
      end

      def validate_url(url)
        raise ArgumentError, "Invalid URL: #{url}" unless url.match?(/\A#{URI::DEFAULT_PARSER.make_regexp}\z/)
      end

      def request(method, path = nil, **kwargs)
        res = super(method, path, **kwargs)

        Response.new(status: res.status, body: res.body, headers: res.headers)
      end
    end

    class Response
      attr_reader :status, :body, :headers

      def initialize(status:, body:, headers:)
        @status = status
        @body = body
        @headers = headers
      end

      def metadata
        raw['metadata']
      end

      def transcript
        raw.dig('results', 'channels', 0, 'alternatives', 0, 'transcript')
      end

      def words
        raw.dig('results', 'channels', 0, 'alternatives', 0, 'words')
      end

      def confidence
        raw.dig('results', 'channels', 0, 'alternatives', 0, 'confidence')
      end

      def raw
        JSON.parse(@body)
      end
    end
  end
end
