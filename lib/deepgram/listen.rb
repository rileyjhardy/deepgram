# frozen_string_literal: true

module Deepgram
  module Listen
    class Client < Base
      def initialize
        super

        @connection.path_prefix = 'v1/listen'
      end

      def transcribe(path:, content_type: 'audio/wav')
        response = @connection.post do |request|
          request.headers['Content-Type'] = content_type
          request.body = File.binread(path)
        end

        response.body
      end
    end
  end
end
