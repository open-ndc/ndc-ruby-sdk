require_relative 'test_helper'

class NDCAirShoppingTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an invalid AirShopping request(missing date)" do

    let(:invalid_query_params_no_date) do
      {
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
    end

    setup do
      @ndc_client = NDCClient::Base.new(@@ndc_config)
    end

    test "AirShopping request requires Departure/Date" do
      assert_raises(NDCClient::NDCErrors::NDCInvalidServerResponse) {
        @@ndc_response = @ndc_client.request(:AirShopping, invalid_query_params_no_date)
      }
    end

  end



  describe "Sends an invalid AirShopping request(missing destination)" do

    let(:invalid_query_params_no_dest) do
      {
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
    end

    setup do
      @ndc_client = NDCClient::Base.new(@@ndc_config)
    end

    test "AirShopping request requires Departure/Date" do
      assert_raises(NDCClient::NDCErrors::NDCInvalidServerResponse) {
        @@ndc_response = @ndc_client.request(:AirShopping, invalid_query_params_no_dest)
      }
    end

  end


  describe "Sends a valid AirShopping request" do

    let(:valid_query_params) do
      {
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
    end

    setup do
      @ndc_client = NDCClient::Base.new(@@ndc_config)
      @ndc_response = @ndc_client.request(:AirShopping, valid_query_params)
      @ndc_parsed_response = @ndc_response.parsed_response
    end


    test "AirShopping request is valid" do
      assert @ndc_response.valid?
    end

    test "Response includes Success element" do
      assert @ndc_parsed_response.hpath?("AirShoppingRS/Success")
    end

    test "MessageVersion is ok" do
      assert @ndc_parsed_response.hpath?('AirShoppingRS/Document')
      assert @ndc_parsed_response.hpath?('AirShoppingRS/Document/MessageVersion'), "15.2"
    end

    test "ShoppingResponseIDs is ok" do
      assert @ndc_parsed_response.hpath?('AirShoppingRS/ShoppingResponseIDs')
      assert @ndc_parsed_response.hpath?('AirShoppingRS/ShoppingResponseIDs/ResponseID')
    end

    test "Airline Offer is present" do
      assert @ndc_parsed_response.hpath?('AirShoppingRS/OffersGroup/AirlineOffers')
      assert @ndc_parsed_response.hpath?('AirShoppingRS/OffersGroup/AirlineOffers/TotalOfferQuantity')
    end

    test "Airline Offers expiration are valid" do
      @ndc_parsed_response.hpath('AirShoppingRS/OffersGroup/AirlineOffers').each{ |aoffer|
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
