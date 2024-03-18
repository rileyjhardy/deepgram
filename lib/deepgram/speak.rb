# frozen_string_literal: true

module Deepgram
  module Speak
    class Client < Base
      def initialize
        super

        @connection.path_prefix = 'v1/speak'
        @connection.headers['Content-Type'] = 'application/json'
      end

      def speak(text:, **kwargs)
        @connection.post do |request|
          request.params.merge!(kwargs)
          request.body = JSON.generate(text: text)
        end
      end

      def speak_async(text:, callback_url:, **kwargs)
        @connection.post do |request|
          request.params.merge!(kwargs)
          request.params[:callback] = callback_url
          request.body = JSON.generate(text: text)
        end
      end
    end
  end
end
