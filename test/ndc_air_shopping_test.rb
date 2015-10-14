require 'test_helper'

class NDCAirShoppingTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  VALID_REQUEST_PARAMS = {
      CoreQuery: {
        OriginDestinations: {
          OriginDestination: {
            Departure: {
              AirportCode: 'MUC',
              Date: '2016-04-01'
            },
            Arrival: {
              AirportCode: 'LHR'
            }
          }
        }
      }
    }


  describe "Sends an invalid AirShopping request" do

    ndc_config = YAML.load_file('test/config/ndc-iata-kronos.yml')
    @@ndc_client = NDCClient::Base.new(ndc_config)

    query_params = {
      CoreQuery: {
        OriginDestinations: {
          OriginDestination: {
            Departure: {
              AirportCode: 'MUC'
            },
            Arrival: {
              AirportCode: 'LHR'
            }
          }
        }
      }
    }

    test "AirShopping request requires Departure/Date" do
      assert_raises(NDCClient::NDCErrors::NDCInvalidResponseFormat) {
        @@ndc_response = @@ndc_client.request(:AirShopping, query_params)
      }
    end

    query_params = {
      CoreQuery: {
        OriginDestinations: {
          OriginDestination: {
            Departure: {
              AirportCode: 'MUC',
              Date: '2016-04-01'
            },
            Arrival: {
            }
          }
        }
      }
    }

    test "AirShopping request requires Arrival data" do
      assert_raises(NDCClient::NDCErrors::NDCInvalidResponseFormat) {
        @@ndc_response = @@ndc_client.request(:AirShopping, query_params)
      }
    end

  end


  describe "Sends a valid AirShopping request" do

    ndc_config = YAML.load_file('test/config/ndc-iata-kronos.yml')
    @@ndc_client = NDCClient::Base.new(ndc_config)

    @@ndc_response = @@ndc_client.request(:AirShopping, VALID_REQUEST_PARAMS)


    test "AirShopping request is valid" do
      assert @@ndc_client.valid_response?
    end

    test "Response includes Success element" do
      refute_nil @@ndc_response["AirShoppingRS"].has_key?("Success")
    end

    test "Document version is ok" do
      refute_empty @@ndc_response.hpath('AirShoppingRS/Document')
      assert_equal @@ndc_response.hpath('AirShoppingRS/Document/ReferenceVersion'), "1.0"
    end

    test "ShoppingResponseID is ok" do
      refute_empty @@ndc_response.hpath('AirShoppingRS/ShoppingResponseID')
      refute_empty @@ndc_response.hpath('AirShoppingRS/ShoppingResponseID/ResponseID')
    end

    test "Airline Offer is present" do
      refute_empty @@ndc_response.hpath('AirShoppingRS/OffersGroup/AirlineOffers')
      refute_empty @@ndc_response.hpath('AirShoppingRS/OffersGroup/AirlineOffers/TotalOfferQuantity')
    end

    test "Airline Offers expiration are valid" do
      @@ndc_response.hpath('AirShoppingRS/OffersGroup/AirlineOffers').each{ |aoffer|
        if aoffer.first == "AirlineOffer"
          aoffer.last.each{|offer|
            refute_nil offer.hpath('TimeLimits/OfferExpiration/@Timestamp')
            assert DateTime.parse(offer.hpath('TimeLimits/OfferExpiration/@Timestamp')).to_time > Time.now
          }
        end
      }
    end

  end

end
