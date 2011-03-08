module RubyFPS::API #:nodoc:
  class Base < RubyFPS::Model
    # This compiles an API request object into a URL, sends it to Amazon, and processes
    # the response.
    def submit
      begin
        url = RubyFPS.api_endpoint + '?' + RubyFPS.query_string(self.to_params)
        response = RestClient.get(url)
        self.class::Response.from_xml(response.body)
      rescue RestClient::BadRequest, RestClient::Unauthorized, RestClient::Forbidden => e
        RubyFPS::API::ErrorResponse.from_xml(e.response.body)
      end
    end

    # Converts the API request object into parameters and signs them.
    def to_params
      params = self.to_hash.merge(
        'Action' => action_name,
        'AWSAccessKeyId' => RubyFPS.access_key,
        'Version' => RubyFPS::API_VERSION,
        'Timestamp' => format_value(Time.now)
      )

      params['SignatureVersion'] = 2
      params['SignatureMethod'] = 'HmacSHA256'
      params['Signature'] = RubyFPS.signature(RubyFPS.api_endpoint, params)

      params
    end

    class BaseResponse < RubyFPS::Model
      attribute :request_id

      # Parses Amazon's XML response to REST requests and instantiates the response.
      def self.from_xml(xml)
        hash = MultiXml.parse(xml)
        response_key = hash.keys.find{|k| k.match(/Response$/)}
        new(hash[response_key])
      end

      def initialize(hash) #:nodoc:
        assign(hash['ResponseMetadata'])
        result_key = hash.keys.find{|k| k.match(/Result$/)}
        assign(hash[result_key]) if hash[result_key] # not all APIs have a result object
      end
    end

    protected

    def action_name #:nodoc:
      self.class.to_s.split('::').last
    end
  end
end
