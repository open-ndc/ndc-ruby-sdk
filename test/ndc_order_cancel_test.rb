require 'test_helper'

class NDCOrderCancelTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an valid OrderCancel request" do

    ndc_config = YAML.load_file('test/config/ndc-iata-kronos.yml')
    @@ndc_client = NDCClient::Base.new(ndc_config)

    # @@ndc_response = @@ndc_client.request(:AirShopping, NDCAirShoppingTest::VALID_REQUEST_PARAMS)
    # @response_id = @@ndc_response.hpath('AirShoppingRS/ShoppingResponseIDs/ResponseID')
    #
    # @@ndc_response = @@ndc_client.request(:OrderCancel, query_params)
    #
    # puts "DEBUG ::: @@ndc_response[:OrderViewRS][:Order] -> #{@@ndc_response[:OrderViewRS][:Order]}"
    #
    #
    # query_params = {
    #   Query: {
    #     OrderId: {
    #       _Owner: "9A",
    #       __Text: "F9A18I",
    #     }
    #   }
    # }

    # @@ndc_response = @@ndc_client.request(:OrderCancel, query_params)
    #
    # test "OrderCancel response is valid" do
    #   assert @@ndc_client.valid_response?
    # end
    #
    # test "Document version is ok" do
    #   refute_empty @@ndc_response.hpath('OrderCancelRS/Document')
    #   assert_equal @@ndc_response.hpath('OrderCancelRS/Document/ReferenceVersion'), "1.0"
    # end
    #
    # test "Response includes Success element" do
    #   refute_nil @@ndc_response["OrderCancelRS"].has_key?("Success")
    # end

  end

end
