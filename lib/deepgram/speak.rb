# frozen_string_literal: true

module Deepgram
  module Speak
    class Client < Base
      def initialize
        super

        @connection.path_prefix = 'v1/speak'
      end

      def speak(text:)
        response = @connection.post do |request|
          request.headers['Content-Type'] = 'application/json'
          request.body = JSON.generate(text: text)
        end

        response.body
      end
    end
  end
end
