require_relative 'test_helper'

class NDCServicePriceTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an valid ServicePrice request" do

    let(:airshopping_valid_query_params) do
      {
        CoreQuery: {
          OriginDestinations: {
            OriginDestination: {
              Departure: {
                AirportCode: 'SXF',
                Date: '2018-12-25'
              },
              Arrival: {
                AirportCode: 'MAD'
              }
            }
          }
        }
      }
    end

    let(:valid_query_params) {
      {
        ShoppingResponseIDs: {
          ResponseID: @response_id
        }
      }
    }

    setup do
      @ndc_client = NDCClient::Base.new(@@ndc_config)
      @ndc_response = @ndc_client.request(:AirShopping, airshopping_valid_query_params)
      @response_id = @ndc_response.parsed_response.hpath('AirShoppingRS/ShoppingResponseIDs/ResponseID')
      @ndc_response = @ndc_client.request(:ServicePrice, valid_query_params)
      @ndc_parsed_response = @ndc_response.parsed_response
    end

    test "ServicePrice response is valid" do
      assert @ndc_response.valid?
    end

    test "MessageVersion is present" do
      assert @ndc_parsed_response.hpath?("ServicePriceRS/Document")
      assert @ndc_parsed_response.hpath?("ServicePriceRS/Document/MessageVersion")
    end

    test "Response includes Success element" do
      assert @ndc_parsed_response.hpath?("ServicePriceRS/Success")
    end

  end

end
