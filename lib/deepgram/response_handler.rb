# frozen_string_literal: true

require_relative 'exception'

module Deepgram
  # The ResponseHandler module provides a method for handling responses
  # from the Deepgram API and raising appropriate exceptions based on
  # the HTTP status code.
  module ResponseHandler
    # Handles the response from the Deepgram API.
    #
    # @param res [Faraday::Response] The response object from the API request.
    #
    # @raise [Deepgram::BadRequestError] If the response has a 400 status code.
    # @raise [Deepgram::UnauthorizedError] If the response has a 401 status code.
    # @raise [Deepgram::ForbiddenError] If the response has a 403 status code.
    # @raise [Deepgram::NotFoundError] If the response has a 404 status code.
    # @raise [Deepgram::RateLimitExceededError] If the response has a 429 status code.
    # @raise [Deepgram::InternalServerErrorError] If the response has a 500 status code.
    # @raise [Deepgram::BadGatewayError] If the response has a 502 status code.
    # @raise [Deepgram::ServiceUnavailableError] If the response has a 503 status code.
    #
    # @return [Faraday::Response] The response object if the status code is between 200 and 226.
    def handle_response(res) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
      case res.status
      when 200..226 then res
      when 400 then raise Deepgram::BadRequest.new(res.body, code: res.status, headers: res.headers)
      when 401 then raise Deepgram::Unauthorized.new(res.body, code: res.status, headers: res.headers)
      when 403 then raise Deepgram::Forbidden.new(res.body, code: res.status, headers: res.headers)
      when 404 then raise Deepgram::NotFound.new(res.body, code: res.status, headers: res.headers)
      when 429 then raise Deepgram::RateLimitExceeded.new(res.body, code: res.status, headers: res.headers)
      when 500 then raise Deepgram::InternalServerError.new(res.body, code: res.status, headers: res.headers)
      when 502 then raise Deepgram::BadGateway.new(res.body, code: res.status, headers: res.headers)
      when 503 then raise Deepgram::ServiceUnavailable.new(res.body, code: res.status, headers: res.headers)
      end
    end
  end
end
