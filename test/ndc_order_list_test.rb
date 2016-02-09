require_relative 'test_helper'

class NDCOrderListTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an valid OrderList request" do

    @@ndc_client = NDCClient::Base.new(@@ndc_config)

    #TODO Should take OrderId from a CreateOrder Request

    query_params = {
      Query: {
        Filters: {
          Airline: {
            AirlineID: "C9"
          }
        }
      }
    }

    # Test disabled until full server compliancy
    # @@ndc_response = @@ndc_client.request(:OrderList, query_params)
    #
    # test "OrderList response is valid" do
    #   assert @@ndc_client.valid_response?
    # end
    #
    # test "MessageVersion is ok" do
    #   refute_empty @@ndc_response.hpath('OrderListRS/Document')
    #   assert_equal @@ndc_response.hpath('OrderListRS/Document/MessageVersion'), "15.2"
    # end
    #
    # test "Response includes Success element" do
    #   refute_nil @@ndc_response["OrderListRS"].has_key?("Success")
    # end

  end

end
