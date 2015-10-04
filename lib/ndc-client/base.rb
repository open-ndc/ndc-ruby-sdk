module NDCClient

  class Base
    # attr_accessor :endpoint, :wsdl, :status, :errors
    ATTRIB_CONVERTER = lambda {|key, value| [key, value]}

    def initialize(config = {})
      @label = config["label"]
      if config.is_a?(Hash) && config["rest"]
        @options = config["options"]
        @rest_config = config["rest"]
        RestClient.log = Logger.new("./log/ndc-#{@label.downcase}.log")
        @client = RestClient::Resource.new @rest_config['url'], @rest_config
        @status = :initialized
      end
    end

    def ready?
      @status == :initialized
    end

    def request(method, params)
      case method
      when :AirShopping
        payload_message = Messages::AirShoppingRQ.new(params, @options)
        response = rest_call_with_message(method, payload_message)
        if valid_response?
          if parse_response!
            # binding.pry
            if @parsed_response["AirShoppingRS"]
              return @parsed_response
            else
              raise NDCErrors::NDCInvalidResponseFormat, "Expecting an AirShoppingRS Document"
            end
          else
            raise NDCErrors::NDCParseError, "Expecting an AirShoppingRS Document"
          end
        else
          raise NDCErrors::NDCInvalidServerResponse, "Expecting HTTP StatusOK"
        end
      else
        raise NDCErrors::NDCUnknownMethod, "Method #{method} is unknown."
      end
    end

    def status
      @status
    end

    def response
      @response
    end

    def parsed_response
      @parsed_response
    end

    def valid_response?
      @response.code == 200
    end

    private

    def rest_call_with_message(method, message)
      @method = method
      begin
        @status = :request_sent
        @response = @client.post message.to_xml, {'Content-Type' => 'application/xml', 'Accept' => 'application/xml', 'User-Agent' => 'NDC Ruby SDK V0.x'}
        @status = :status_ok if @response.code == 200
      rescue RestClient::ExceptionWithResponse => error
        @status = :request_error
        @error = error
      end
    end

    def soap_call_with_message(method, message)
      @method = method
      @status = :request_sent
      @response = @client.call(method, message: message.to_xml_with_body_wrap)
      @status = :request_complete
    end

    def parse_response!
      parser = Nori.new
      @parsed_response = parser.parse @response
      return !@parsed_response.nil?
    end

  end

end
