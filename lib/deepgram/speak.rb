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
        request(:post, **kwargs) do |request|
          request.body = JSON.generate(text: text)
        end
      end

      def speak_async(text:, callback_url:, **kwargs)
        request(:post, callback_url: callback_url, **kwargs) do |request|
          request.body = JSON.generate(text: text)
        end
      end

      private

      def request(method, path = nil, **kwargs)
        res = super(method, path, **kwargs)

        Response.new(status: res.status, body: res.body, headers: res.headers)
      end
    end

    class Response
      def initialize(status:, body:, headers:)
        @status = status
        @body = body
        @headers = headers
      end

      def raw
        JSON.parse(@body)
      end

      def request_id
        raw['request_id']
      end

      def file
        @body
      end
    end
  end
end
