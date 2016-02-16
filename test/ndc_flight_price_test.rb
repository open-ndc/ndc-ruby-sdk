require_relative 'test_helper'

class NDCFlightPriceTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an invalid FlightPrice request" do

    let(:invalid_query_params) do
      {
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
    end

    setup do
      @ndc_client = NDCClient::Base.new(@@ndc_config)
    end

    test "Flight requires arrival deltails" do
      assert_raises(NDCClient::NDCErrors::NDCInvalidServerResponse) {
        @ndc_client.request(:FlightPrice, invalid_query_params)
      }
    end

  end


  describe "Sends a valid FlightPrice request" do

    let(:valid_query_params) do
      {
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
    end

    let(:valid_query_params_too) do
      {
        Query: {
          OriginDestination: [
            {
              Flight: [
                {
                  Departure: {
                      AirportCode: 'SXF',
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
    end



    setup do
      @ndc_client = NDCClient::Base.new(@@ndc_config)
      @ndc_response = @ndc_client.request(:FlightPrice, valid_query_params_too)
      @ndc_parsed_response = @ndc_response.parsed_response
    end

    test "FlightPrice request is valid" do
      assert @ndc_response.valid?
    end

    test "ShoppingResponseIDs is ok" do
      refute_empty @ndc_parsed_response.hpath('FlightPriceRS/ShoppingResponseIDs')
      refute_empty @ndc_parsed_response.hpath('FlightPriceRS/ShoppingResponseIDs/ResponseID')
    end

    test "Response includes Success element" do
      refute_nil @ndc_parsed_response.deep_symbolize_keys![:FlightPriceRS].has_key?("Success")
    end

  end

end
