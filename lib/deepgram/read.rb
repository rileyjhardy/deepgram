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
        res = request(:post, **kwargs) do |request|
          request.body = JSON.generate(text: text)
        end

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
