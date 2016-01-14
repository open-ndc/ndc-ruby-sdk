require 'test_helper'

class NDCOrderRetrieveTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an valid OrderRetrieve request" do

    @@ndc_client = NDCClient::Base.new(@@ndc_config)

    #TODO Should take OrderId from a CreateOrder Request

    query_params = {
      Query: {
        Filters: {
          OrderId: {
            _Owner: "9A",
            __Text: "F9A18I",
          }
        }
      }
    }

    # Test disabled until full server compliancy
    # @@ndc_response = @@ndc_client.request(:OrderRetrieve, query_params)
    #
    # test "OrderRetrieve response is valid" do
    #   assert @@ndc_client.valid_response?
    # end
    #
    # test "Document version is ok" do
    #   refute_empty @@ndc_response.hpath('OrderViewRS/Document')
    #   assert_equal @@ndc_response.hpath('OrderRetrieveRS/Document/ReferenceVersion'), "1.0"
    # end
    #
    # test "Response includes Success element" do
    #   refute_nil @@ndc_response["OrderViewRS"].has_key?("Success")
    # end

  end

end
