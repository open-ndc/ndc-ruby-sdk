require 'test_helper'

class NDCServiceListTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an valid ServiceList request" do

    ndc_config = YAML.load_file('test/config/ndc-iata-kronos.yml')
    @@ndc_client = NDCClient::Base.new(ndc_config)

    @@ndc_response = @@ndc_client.request(:AirShopping, NDCAirShoppingTest::VALID_REQUEST_PARAMS)
    @response_id = @@ndc_response.hpath('AirShoppingRS/ShoppingResponseID/ResponseID')

    query_params = {
      ShoppingResponseID: {
        ResponseID: @response_id
      }
    }

    @@ndc_response = @@ndc_client.request(:ServiceList, query_params)

    test "ServiceList response is valid" do
      assert @@ndc_client.valid_response?
    end

    test "Document version is ok" do
      refute_empty @@ndc_response.hpath('ServiceListRS/Document')
      assert_equal @@ndc_response.hpath('ServiceListRS/Document/ReferenceVersion'), "1.0"
    end

    test "Response includes Success element" do
      refute_nil @@ndc_response["ServiceListRS"].has_key?("Success")
    end

  end

end
