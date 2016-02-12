require_relative 'test_helper'

class NDCServiceListTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  @@ndc_client = NDCClient::Base.new(@@ndc_config)

  describe "Sends an invalid ServiceList request (random ShoppingResponseID)" do

    @response_id = Digest::MD5.new.hexdigest

    query_params = {
      ShoppingResponseIDs: {
        ResponseID: @response_id
      }
    }

    @@ndc_response = @@ndc_client.request(:ServiceList, query_params)

    test "ServiceList response is invalid" do
      refute @@ndc_client.valid_response?
    end

  end

  describe "Sends an valid ServiceList request" do

    @@ndc_response = @@ndc_client.request(:AirShopping, NDCAirShoppingTest::VALID_REQUEST_PARAMS)
    @response_id = @@ndc_response.hpath('AirShoppingRS/ShoppingResponseIDs/ResponseID')

    query_params = {
      ShoppingResponseIDs: {
        ResponseID: @response_id
      }
    }

    @@ndc_response = @@ndc_client.request(:ServiceList, query_params)

    test "ServiceList response is valid" do
      assert @@ndc_client.valid_response?
    end

    test "MessageVersion is ok" do
      refute_empty @@ndc_response.hpath('ServiceListRS/Document')
      assert_equal @@ndc_response.hpath('ServiceListRS/Document/MessageVersion'), "15.2"
    end

    test "Response includes Success element" do
      assert_true @@ndc_response["ServiceListRS"].has_key?("Success")
    end

    test "Response includes ServiceList listing" do
      refute_empty @@ndc_response["ServiceListRS/DataLists"].has_key?("ServiceList")
    end

  end

end
