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

  DEFAULT_HEADERS = {'Content-Type' => 'application/xml', 'Accept' => 'application/xml', 'User-Agent' => 'NDC Ruby SDK V0.1'}

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
      raise NDCErrors::NDCUnsupportedMethod.new("Not a valid NDC method") unless ACCEPTABLE_NDC_METHODS[method].present?
      @method = method
      @request_name = ACCEPTABLE_NDC_METHODS[method].first.to_s
      @response_name = ACCEPTABLE_NDC_METHODS[method].last.to_s
      payload_message = Messages.class_eval(@request_name).new(params)
      response = rest_call_with_message(method, payload_message)
      if @status == :status_ok
        parse_response!
        if @parsed_response.hpath(@response_name).present? && @parsed_response.hpath("#{@response_name}/Errors").nil?
          return self
        else
          raise NDCErrors::NDCInvalidResponseFormat.new(400, "Expecting a valid #{@response_name}. Errors: #{@parsed_response.hpath("#{@response_name}/Errors")}")
          return self
        end
      else
        raise NDCErrors::NDCInvalidServerResponse.new("Expecting HTTP Status OK but retuned: #{@response_code}")
        return self
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

    def valid?
      @status == :status_ok && @parsed_response["Errors"].nil?
    end

    private

    def rest_call_with_message(method, message)
      @method = method
      begin
        @status = :request_sent
        @response = @client.post message.to_xml, DEFAULT_HEADERS.merge({'Authorization-Key' => @rest_config['headers']['Authorization-Key']})
        @status = :status_ok # Otherwise raises exception
        return @response
      rescue RestClient::ExceptionWithResponse => exception
        @status = :status_wrong
        @response = exception.response
        @exception = exception
        return @exception
      ensure
        @response_code = @response.code
      end
    end

    # def soap_call_with_message(method, message)
    #   @method = method
    #   @status = :request_sent
    #   @response = @client.call(method, message: message.to_xml_with_body_wrap)
    #   @status = :status_ok
    # end

    def parse_response!
      parser = Nori.new
      @parsed_response = parser.parse @response
      return !@parsed_response.nil?
    end

  end

end
