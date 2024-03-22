# frozen_string_literal: true

require 'deepgram/fixtures'
module Deepgram
  module Read
    class Client < Base
      def initialize(language = 'en')
        super

        @connection.path_prefix = 'v1/read'
        @connection.params[:language] = language
        @connection.headers['Content-Type'] = 'application/json'
      end

      def analyze(text:, **kwargs)
        res = post(text, **kwargs)
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

      def metadata
        raw['metadata']
      end

      def summary
        raw.dig('results', 'summary', 'text')
      end

      def topics
        raw.dig('results', 'topics', 'segments')
      end

      def sentiments
        raw.dig('results', 'sentiments', 'segments')
      end

      def intents
        raw.dig('results', 'intents', 'segments')
      end
    end
  end
end
