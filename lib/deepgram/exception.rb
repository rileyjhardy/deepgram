# frozen_string_literal: true

module Deepgram
  class Exception < StandardError
    attr_reader :error_data

    def initialize(message, error_data = {})
      super(message)

      @error_data = error_data
    end
  end

  class HTTPError < Exception
    def headers
      error_data[:headers]
    end

    def http_code
      error_data[:code]
    end
  end

  # transcription errors
  class InsufficientCredits < HTTPError; end
  class RateLimitExceeded < HTTPError; end

  # general errors
  class BadRequest < HTTPError; end
  class Unauthorized < HTTPError; end
  class Forbidden < HTTPError; end
  class NotFound < HTTPError; end
  class InternalServerError < HTTPError; end
  class BadGateway < HTTPError; end
  class ServiceUnavailable < HTTPError; end
  class GatewayTimeout < HTTPError; end
end
