require 'test_helper'

class NDCOrderListTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an valid OrderList request" do

    ndc_config = YAML.load_file('test/config/ndc-iata-kronos.yml')
    @@ndc_client = NDCClient::Base.new(ndc_config)

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

    @@ndc_response = @@ndc_client.request(:OrderList, query_params)

    test "OrderList response is valid" do
      assert @@ndc_client.valid_response?
    end

    test "Document version is ok" do
      refute_empty @@ndc_response.hpath('OrderListRS/Document')
      assert_equal @@ndc_response.hpath('OrderListRS/Document/ReferenceVersion'), "1.0"
    end

    test "Response includes Success element" do
      refute_nil @@ndc_response["OrderListRS"].has_key?("Success")
    end

  end

end
