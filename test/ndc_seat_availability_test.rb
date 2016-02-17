require_relative 'test_helper'

class NDCSeatAvailabilityTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an valid SeatAvailability request" do

    let(:query_params) {
    {
      Query: {
        OriginDestination: {
          OriginDestinationReferences: 'OD1'
        }
      },
      DataList: {
        OriginDestinationList: {
          OriginDestination: {
            _OriginDestinationKey: 'OD1',
            DepartureCode: "ARN",
            ArrivalCode: "RIX"
          }
        },
        FlightList: [
          {
            Flight: {
              _FlightKey: 'FL1',
              Journey: {
                Time: 'PT6H55M'
              },
              SegmentReferences: 'SEG1 SEG2'
            }
          }
        ],
        FlightSegmentList: [
          {
            FlightSegment: {
              _SegmentKey: "SEG1",
              Departure: {
                AirportCode: "ARN",
                Date: "2016-05-05",
                Time: "06:00"
              },
              Arrival: {
                AirportCode: "FRA",
                Date: "2016-05-05",
                Time: "08:10",
                AirportName: "Frankfurt International"
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
              ClassOfService: {
                Code: "M"
              },
              FlightDetail: {
                FlightDuration: {
                  Value: "PT2H10M"
                }
              },
            }
          },
          {
            FlightSegment: {
              _SegmentKey: "SEG2",
              Departure: {
                AirportCode: "FRA",
                Date: "2016-05-05",
                Time: "09:50",
                AirportName: "Frankfurt International"
              },
              Arrival: {
                AirportCode: "RIX",
                Date: "2016-05-05",
                Time: "12:55",
                AirportName: "Riga International"
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
              ClassOfService: {
                Code: "M"
              },
              FlightDetail: {
                FlightDuration: {
                  Value: "PT3H5M"
                }
              }
            }
          }
        ]
      }
    }}


    setup do
      @ndc_client = NDCClient::Base.new(@@ndc_config)
      @ndc_response = @ndc_client.request(:SeatAvailability, query_params)
      @ndc_parsed_response = @ndc_response.parsed_response
    end

    test "SeatAvailability request is valid" do
      assert @ndc_response.valid?
    end

    test "MessageVersion is ok" do
      refute_empty @ndc_parsed_response.hpath('SeatAvailabilityRS/Document')
      assert_equal @ndc_parsed_response.hpath('SeatAvailabilityRS/Document/MessageVersion'), "15.2"
    end

    test "Response includes Success element" do
      assert @ndc_parsed_response.hpath("SeatAvailabilityRS").has_key?(:Success)
    end

  end

end
