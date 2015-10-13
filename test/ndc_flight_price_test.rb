require 'test_helper'

class NDCFlightPriceTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an invalid FlightPrice request" do

    ndc_config = YAML.load_file('test/config/ndc-iata-kronos.yml')
    @@ndc_client = NDCClient::Base.new(ndc_config)

    query_params = {
      Query: {
        OriginDestination: [
          {
            Flight: {
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

    test "Raises a response error" do
      assert_raises(NDCClient::NDCErrors::NDCInvalidResponseFormat) {
        @@ndc_response = @@ndc_client.request(:FlightPrice, query_params)
      }
    end

  end


  describe "Sends a valid FlightPrice request" do

    ndc_config = YAML.load_file('test/config/ndc-iata-kronos.yml')
    @@ndc_client = NDCClient::Base.new(ndc_config)

    query_params = {
      Query: {
        OriginDestination: [
          { Flight: {
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
          }},
          { Flight: {
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
          }}
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

    test "Document version is ok" do
      refute_empty @@ndc_response.hpath('FlightPriceRS/Document')
      assert_equal @@ndc_response.hpath('FlightPriceRS/Document/ReferenceVersion'), "1.0"
    end

    test "ShoppingResponseID is ok" do
      refute_empty @@ndc_response.hpath('FlightPriceRS/ShoppingResponseID')
      refute_empty @@ndc_response.hpath('FlightPriceRS/ShoppingResponseID/ResponseID')
    end

  end

end
