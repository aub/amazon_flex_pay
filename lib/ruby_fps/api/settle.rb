module RubyFPS::API #:nodoc:
  class Settle < Base #:nodoc:
    attribute :reserve_transaction_id
    attribute :transaction_amount, :type => :amount

    class Response < BaseResponse #:nodoc:
      attribute :transaction_id
      attribute :transaction_status, :enumeration => :transaction_status
    end
  end
end
