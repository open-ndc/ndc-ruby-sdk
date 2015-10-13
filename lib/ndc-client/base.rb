module NDCClient

  ACCEPTABLE_NDC_METHODS = {
                              AirShopping: [:AirShoppingRQ, :AirShoppingRS],
                              FlightPrice: [:FlightPriceRQ, :FlightPriceRS],
                              SeatAvailability: [:SeatAvailabilityRQ, :SeatAvailabilityRS],
                              ServiceList: [:ServiceListRQ, :ServiceListRS],
                              ServicePrice: [:ServicePriceRQ, :ServicePriceRS],

                              OrderCreate: [:OrderCreateRQ, :OrderViewRS],
                              OrderList: [:OrderListRQ, :OrderListRS],
                              OrderRetrieve: [:OrderRetrieveRQ, :OrderViewRS],
                              OrderCancel: [:OrderCancelRQ, :OrderCancelRS]
                            }

  class Base

    def initialize(config = {})
      @label = config["label"]
      if config.is_a?(Hash) && config["rest"]
        Config.ndc_config = config["ndc"]
        @rest_config = config["rest"]
        RestClient.log = Logger.new("./log/ndc-#{@label.downcase}.log")
        @client = RestClient::Resource.new @rest_config['url'], @rest_config
        @status = :initialized
      end
    end

    def ready?
      @status == :initialized
    end

    def valid_config?
      Config.valid?
    end

    def request(method, params)
      raise NDCErrors::NDCUnsupportedMethod unless ACCEPTABLE_NDC_METHODS[method].present?
      @method = method
      @request_name = ACCEPTABLE_NDC_METHODS[method].first.to_s
      @response_name = ACCEPTABLE_NDC_METHODS[method].last.to_s
      payload_message = Messages.class_eval(@request_name).new(params)
      response = rest_call_with_message(method, payload_message)

      if @status == :status_ok
        if parse_response! && @parsed_response[@response_name] && @parsed_response[@response_name]["Errors"].nil?
          return @parsed_response
        else
          raise NDCErrors::NDCInvalidResponseFormat, "Expecting a valid #{@response_name}. Errors: #{@parsed_response[@response_name]["Errors"]}"
        end
      else
        raise NDCErrors::NDCInvalidServerResponse, "Expecting HTTP Status OK"
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
      @status == :status_ok && @parsed_response["Errors"].nil?
    end

    private

    def rest_call_with_message(method, message)
      @method = method
      begin
        @status = :request_sent
        @response = @client.post message.to_xml, {'Content-Type' => 'application/xml', 'Accept' => 'application/xml', 'User-Agent' => 'NDC Ruby SDK V0.1'}
        @status = :status_ok if @response.code == 200
        return @response
      rescue RestClient::ExceptionWithResponse => error
        @status = :request_error
        @error = error
        return @error
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
