# frozen_string_literal: true

module Deepgram
  # Base class for all Deepgram API exceptions.
  class Exception < StandardError
    attr_reader :error_data

    # Initializes a new instance of the Exception class.
    #
    # @param message [String] The error message.
    # @param error_data [Hash] Additional error data (e.g., headers, error codes).
    def initialize(message, error_data = {})
      super(message)
      @error_data = error_data
    end
  end

  # Base class for HTTP errors returned by the Deepgram API.
  class HTTPError < Exception
    # Returns the headers associated with the HTTP error.
    #
    # @return [Hash] The headers.
    def headers
      error_data[:headers]
    end

    # Returns the HTTP status code associated with the error.
    #
    # @return [Integer] The HTTP status code.
    def http_code
      error_data[:code]
    end
  end

  # Exception raised when there are insufficient credits to perform a transcription.
  class InsufficientCredits < HTTPError; end

  # Exception raised when the rate limit for API requests has been exceeded.
  class RateLimitExceeded < HTTPError; end

  # Exception raised when the API request is invalid or malformed.
  class BadRequest < HTTPError; end

  # Exception raised when the API request is not authenticated or authorized.
  class Unauthorized < HTTPError; end

  # Exception raised when the API request is not permitted or forbidden.
  class Forbidden < HTTPError; end

  # Exception raised when the requested resource is not found.
  class NotFound < HTTPError; end

  # Exception raised when there is an internal server error on the Deepgram API side.
  class InternalServerError < HTTPError; end

  # Exception raised when there is a bad gateway error on the Deepgram API side.
  class BadGateway < HTTPError; end

  # Exception raised when the Deepgram API service is temporarily unavailable.
  class ServiceUnavailable < HTTPError; end

  # Exception raised when there is a gateway timeout error on the Deepgram API side.
  class GatewayTimeout < HTTPError; end
end
