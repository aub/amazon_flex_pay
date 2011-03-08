module RubyFPS::API #:nodoc:
  class CancelToken < Base #:nodoc:
    attribute :token_id
    attribute :reason_text

    class Response < BaseResponse #:nodoc:
    end
  end
end
