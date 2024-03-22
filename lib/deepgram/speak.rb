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
        res = post(text, **kwargs)

        FileResponse.new(status: res.status, body: res.body, headers: res.headers)
      end

      def speak_async(text:, callback_url:, **kwargs)
        res = post(text, callback_url: callback_url, **kwargs)

        Response.new(status: res.status, body: res.body, headers: res.headers)
      end

      private

      def post(text, **kwargs)
        res = @connection.post do |request|
          request.body = JSON.generate(text: text)
          request.params.merge!(kwargs)
          yield request.params if block_given?
        end

        handle_response(res)
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
        raw.dig('request_id')
      end
    end

    class FileResponse
      def initialize(status:, body:, headers:)
        @status = status
        @body = body
        @headers = headers
      end

      def file
        @body
      end
    end
  end
end
