require_relative 'test_helper'

class NDCServiceListTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an valid ServiceList request" do

    @@ndc_client = NDCClient::Base.new(@@ndc_config)

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
      refute_nil @@ndc_response.deep_symbolize_keys![:ServiceListRS].has_key?("Success")
    end

  end

end
