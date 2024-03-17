# frozen_string_literal: true

module Deepgram
  module Read
    class Client < Base
      def initialize(language: 'en', **kwargs)
        super

        @options = { summarize: true }.merge(kwargs)
        @language = language
        @connection.path_prefix = 'v1/read'
      end

      def analyze(text:)
        response = @connection.post do |request|
          request.headers['Content-Type'] = 'application/json'
          request.params[:language] = @language
          request.params[:summarize] = @options[:summarize]
          request.body = JSON.generate(text: text)
        end

        response.body
      end
    end
  end
end
