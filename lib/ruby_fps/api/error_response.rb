module RubyFPS::API #:nodoc:
  class ErrorResponse < RubyFPS::Model #:nodoc:
    # Re-implements the XML parsing because ErrorResponse does not inherit from BaseResponse.
    def self.from_xml(xml)
      new(MultiXml.parse(xml)['Response'])
    end

    attribute :request_id

    attr_reader :errors
    def errors=(val)
      @errors = [val['Error']].flatten.map{|e| Error.new(e)}
    end

    class Error < RubyFPS::Model #:nodoc:
      attribute :code
      attribute :message
    end
  end
end
