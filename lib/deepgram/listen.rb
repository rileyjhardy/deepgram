# frozen_string_literal: true

module Deepgram
  module Listen
    class Client < Base
      def initialize
        super
        @connection.path_prefix = 'listen'
        @connection.headers['Content-Type'] = 'application/json'
        @connection.headers['Accept'] = 'application/json'
      end

      def transcribe_file(path:, audio_format: 'audio/wav', **kwargs)
        validate_file_path(path)
        @connection.post do |request|
          request.headers['Content-Type'] = audio_format
          request.params.merge!(kwargs)
          request.body = File.binread(path)
        end
      end

      def transcribe_url(url:, **kwargs)
        validate_url(url)
        @connection.post do |request|
          request.params.merge!(kwargs)
          request.body = JSON.generate(url: url)
        end
      end

      private

      def validate_file_path(path)
        raise ArgumentError, "Invalid file path: #{path}" unless File.exist?(path)
      end

      def validate_url(url)
        raise ArgumentError, "Invalid URL: #{url}" unless url.match?(%r{\A#{URI::DEFAULT_PARSER.make_regexp}\z})
      end
    end
  end
end
