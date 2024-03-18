# frozen_string_literal: true

module Deepgram
  module Read
    class Client < Base
      def initialize(language = 'en')
        super

        @connection.path_prefix = 'v1/read'
        @connection.params[:language] = language
        @connection.headers['Content-Type'] = 'application/json'
      end

      def summarize(text:, **kwargs)
        post(text, **kwargs) do |params|
          params[:summarize] = true
        end
      end

      def topics(text:, **kwargs)
        post(text, **kwargs) do |params|
          params[:topics] = true
        end
      end

      def sentiment(text:, **kwargs)
        post(text, **kwargs) do |params|
          params[:sentiment] = true
        end
      end

      def intents(text:, **kwargs)
        post(text, **kwargs) do |params|
          params[:intents] = true
        end
      end

      private

      def post(text, **kwargs)
        @connection.post do |request|
          request.body = JSON.generate(text: text)
          request.params.merge!(kwargs)
          yield request.params if block_given?
        end
      end
    end
  end
end
