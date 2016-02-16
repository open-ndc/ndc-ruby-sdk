require_relative 'test_helper'

class NDCServiceListTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  setup do
    @ndc_client = NDCClient::Base.new(@@ndc_config)
  end

  describe "Sends an invalid ServiceList request (random ShoppingResponseID)" do

    let(:response_id) {Digest::MD5.new.hexdigest}

    let(:query_params) {
      {
        ShoppingResponseIDs: {
          ResponseID: response_id
        }
      }
    }

    test "ServiceList response is invalid" do
      assert_raise NDCClient::NDCErrors::NDCInvalidServerResponse do
        ndc_response = @ndc_client.request(:ServiceList, query_params)
      end
    end

  end

  describe "Sends an valid ServiceList request" do

    let(:airshopping_valid_query_params) do
      {
        CoreQuery: {
          OriginDestinations: {
            OriginDestination: {
              Departure: {
                AirportCode: 'SXF',
                Date: '2016-03-01'
              },
              Arrival: {
                AirportCode: 'MAD'
              }
            }
          }
        }
      }
    end

    let(:valid_query_params) do
      {
        ShoppingResponseIDs: {
          ResponseID: @response_id
        }
      }
    end

    setup do
      # Gets a valid ShoppingResponseID from an AirShoppingRS
      @ndc_response = @ndc_client.request(:AirShopping, airshopping_valid_query_params)
      @response_id = @ndc_response.parsed_response.hpath('AirShoppingRS/ShoppingResponseIDs/ResponseID')
      @ndc_response = @ndc_client.request(:ServiceList, valid_query_params)
      @ndc_parsed_response = @ndc_response.parsed_response
    end


    test "Get aServiceList response is valid" do
      @ndc_response = @ndc_client.request(:ServiceList, valid_query_params)
      assert @ndc_response.valid?
    end

    test "MessageVersion is ok" do
      refute_empty @ndc_parsed_response.hpath('ServiceListRS/Document')
      assert_equal @ndc_parsed_response.hpath('ServiceListRS/Document/MessageVersion'), "15.2"
    end

    test "Response includes Success element" do
      assert_true @ndc_parsed_response.hpath["ServiceListRS"].has_key?("Success")
    end

    test "Response includes ServiceList listing" do
      refute_empty @ndc_parsed_response.hpath["ServiceListRS/DataLists"].has_key?("ServiceList")
    end

  end

end
