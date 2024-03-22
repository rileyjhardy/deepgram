# frozen_string_literal: true

module Deepgram
  module ResponseHandler
    def handle_response(res)
      case res.status
      when 200..226 then res
      when 400 then raise Deepgram::BadRequestError.new(res.body, code: res.status, headers: res.headers)
      when 401 then raise Deepgram::UnauthorizedError.new(res.body, code: res.status, headers: res.headers)
      when 403 then raise Deepgram::ForbiddenError.new(res.body, code: res.status, headers: res.headers)
      when 404 then raise Deepgram::NotFoundError.new(res.body, code: res.status, headers: res.headers)
      when 429 then raise Deepgram::RateLimitExceededError.new(res.body, code: res.status, headers: res.headers)
      when 500 then raise Deepgram::InternalServerErrorError.new(res.body, code: res.status, headers: res.headers)
      when 502 then raise Deepgram::BadGatewayError.new(res.body, code: res.status, headers: res.headers)
      when 503 then raise Deepgram::ServiceUnavailableError.new(res.body, code: res.status, headers: res.headers)
      end
    end
  end
end
