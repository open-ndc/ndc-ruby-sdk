require_relative 'test_helper'

class NDCFlightPriceTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an invalid FlightPrice request" do

    @@ndc_client = NDCClient::Base.new(@@ndc_config)

    invalid_query_params = {
      Query: {
        OriginDestination: [
          {
            Flight: {
              Departure: {
                AirportCode: 'ARN',
                Date: '2016-05-05',
                Time: '06:00'
              },
              MarketingCarrier: {
                AirlineID: "C9",
                Name: "Kronos Air",
                FlightNumber: "809"
              },
              OperatingCarrier: {
                AirlineID: "C9",
                Name: "Kronos Air",
                FlightNumber: "809"
              },
              Equipment: {
                AircraftCode: "32A",
                Name: ""
              },
              CabinType: {
                Code: "M",
                Definition: "Economy/coach discounted"
              }
            }
          }
        ]
      },
      DataLists: {
        OriginDestinationList: {
          OriginDestination: {
              DepartureCode: "ARN",
              ArrivalCode: "RIX"
          }
        }
      }
    }

    test "Flight requires arrival deltails" do
      assert_raises(NDCClient::NDCErrors::NDCInvalidServerResponse) {
        @@ndc_response = @@ndc_client.request(:FlightPrice, invalid_query_params)
      }
    end

  end


  describe "Sends a valid FlightPrice request" do

    @@ndc_client = NDCClient::Base.new(@@ndc_config)

    query_params = {
      Query: {
        OriginDestination: [
          { Flight: [{
            Departure: {
              AirportCode: 'ARN',
              Date: '2016-05-05',
              Time: '06:00'
            },
            Arrival: {
              AirportCode: 'FRA',
              Date: '2016-05-05',
              Time: '08:10',
              AirportName: 'Frankfurt International'
            },
            MarketingCarrier: {
              AirlineID: "C9",
              Name: "Kronos Air",
              FlightNumber: "809"
            },
            OperatingCarrier: {
              AirlineID: "C9",
              Name: "Kronos Air",
              FlightNumber: "809"
            },
            Equipment: {
              AircraftCode: "32A",
              Name: ""
            },
            CabinType: {
              Code: "M",
              Definition: "Economy/coach discounted"
            }
          }]},
          { Flight: [{
            Departure: {
              AirportCode: 'FRA',
              Date: '2016-05-05',
              Time: '09:50'
            },
            Arrival: {
              AirportCode: 'RIX',
              Date: '2016-05-05',
              Time: '15:55',
              AirportName: 'Riga International'
            },
            MarketingCarrier: {
              AirlineID: "C9",
              Name: "Kronos Air",
              FlightNumber: "890"
            },
            OperatingCarrier: {
              AirlineID: "C9",
              Name: "Kronos Air",
              FlightNumber: "890"
            },
            Equipment: {
              AircraftCode: "321",
              Name: "321 - AIRBUS INDUSTRIE A321 JET"
            },
            CabinType: {
              Code: "M",
              Definition: "Economy/coach discounted"
            }
          }]}
        ]
      },
      DataLists: {
        OriginDestinationList: {
          OriginDestination: {
              DepartureCode: "ARN",
              ArrivalCode: "RIX"
          }
        }
      }
    }

    @@ndc_response = @@ndc_client.request(:FlightPrice, query_params)

    test "FlightPrice request is valid" do
      assert @@ndc_client.valid_response?
    end

    test 'Fetching result' do
      ndc_client = NDCClient::Base.new(@@ndc_config)
      params = {
          Query: {
              OriginDestination: [
                  {
                      Flight: [
                          {
                              Departure: {
                                  AirportCode: 'SFX',
                                  Date: '2016-04-01',
                                  Time: '20:30'
                              },
                              Arrival: {
                                  AirportCode: 'MAD',
                                  Date: '2016-04-02',
                                  Time: '23:10'
                              },
                              MarketingCarrier: {
                                  AirlineID: 'id',
                                  FlightNumber: '1'
                              },
                              OperatingCarrier: {
                                  AirlineID: 'id',
                                  FlightNumber: '1'
                              },
                              Equipment: {
                                  AircraftCode: '333'
                              },
                              CabinType: {
                                  Code: 'M'
                              }
                          }
                      ]
                  },
              ]
          }
      }
      @@ndc_response = ndc_client.request(:FlightPrice, params)
      assert !@@ndc_response.hpath('FlightPriceRS/PricedFlightOffers').size.zero?
    end

    test "ShoppingResponseIDs is ok" do
      refute_empty @@ndc_response.hpath('FlightPriceRS/ShoppingResponseIDs')
      refute_empty @@ndc_response.hpath('FlightPriceRS/ShoppingResponseIDs/ResponseID')
    end


    test "Response includes Success element" do
      refute_nil @@ndc_response.deep_symbolize_keys![:FlightPriceRS].has_key?("Success")
    end

    test "MessageVersion is ok" do
      refute_empty @@ndc_response.hpath('FlightPriceRS/Document')
      assert_equal @@ndc_response.hpath('FlightPriceRS/Document/MessageVersion'), "15.2"
    end

  end

end
