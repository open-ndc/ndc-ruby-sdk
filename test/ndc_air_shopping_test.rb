require 'test_helper'

class NDCAirShoppingTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  ndc_config = YAML.load_file('test/config/ndc-iata-kronos.yml')
  @@ndc_client = NDCClient::Base.new(ndc_config)
  query_params = {departure_airport_code: 'MUC', arrival_airport_code: 'LHR', departure_date: '2016-04-01'}
  @@ndc_response = @@ndc_client.request(:AirShopping, query_params)

  setup do
  end

  describe "Has a valid AirShopping response" do

    test "AirShopping request is valid" do
      assert @@ndc_client.valid_response?
    end

    test "Document version is ok" do
      refute_nil @@ndc_response["AirShoppingRS"]["Document"]
      assert_equal @@ndc_response["AirShoppingRS"]["Document"]["ReferenceVersion"], "1.0"
    end

    test "ShoppingResponseID is ok" do
      refute_nil @@ndc_response["AirShoppingRS"]["ShoppingResponseID"]
      refute_nil @@ndc_response["AirShoppingRS"]["ShoppingResponseID"]["ResponseID"]
    end

    test "Airline Offer is present" do
      refute_nil @@ndc_response["AirShoppingRS"]["OffersGroup"]["AirlineOffers"]
      refute_empty @@ndc_response["AirShoppingRS"]["OffersGroup"]["AirlineOffers"]['TotalOfferQuantity']
    end

    test "Airline Offers expiration are valid" do
      @@ndc_response["AirShoppingRS"]["OffersGroup"]["AirlineOffers"].each{ |aoffer|
        if aoffer.first == "AirlineOffer"
          aoffer.last.each{|offer|
            refute_nil offer["TimeLimits"]["OfferExpiration"]["@Timestamp"]
            assert DateTime.parse(offer["TimeLimits"]["OfferExpiration"]["@Timestamp"]).to_time > Time.now
          }
        end
      }
    end

  end

end
