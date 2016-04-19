require_relative 'test_helper'

class NDCSeatAvailabilityTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  #describe "Sends an invalid SeatAvailability" do
    #let(:invalid_query_params) {
    #{
      #Query: {
        #OriginDestination: {
          #OriginDestinationReferences: 'OD1'
        #}
      #},
      #DataList: {
        #OriginDestinationList: {
          #OriginDestination: {
            #_OriginDestinationKey: 'OD1',
            #DepartureCode: "SXF",
            #ArrivalCode: "MAD"
          #}
        #},
        #FlightList: [
          #{
            #Flight: {
              #_FlightKey: 'FL1',
              #Journey: {
                #Time: 'PT6H55M'
              #},
              #SegmentReferences: 'SEG1 SEG2'
            #}
          #}
        #],
        #FlightSegmentList: [
          #{
            #FlightSegment: {
              #_SegmentKey: "SEG1",
              #Departure: {
                #AirportCode: "BLA",
                #Date: "2016-03-01",
                #Time: "20:30"
              #},
              #Arrival: {
                #AirportCode: "MAD",
                #Date: "2016-03-01",
                #Time: "23:10",
                #AirportName: "Madrid Adolfo Suárez International Airport"
              #},
              #MarketingCarrier: {
                #AirlineID: "FA",
                #Name: "Kronos Air",
                #FlightNumber: "809"
              #},
              #OperatingCarrier: {
                #AirlineID: "FA",
                #Name: "Kronos Air",
                #FlightNumber: "809"
              #},
              #Equipment: {
                #AircraftCode: "31F",
                #Name: "E95 EMBRAER 195 JET"
              #},
              #ClassOfService: {
                #Code: "M"
              #},
              #FlightDetail: {
                #FlightDuration: {
                  #Value: "PT2H10M"
                #}
              #},
            #}
          #},
          #{
            #FlightSegment: {
              #_SegmentKey: "SEG2",
              #Departure: {
                #AirportCode: "SXF",
                #Date: "2016-03-01",
                #Time: "20:30",
                #AirportName: "Berlin Schönefeld"
              #},
              #Arrival: {
                #AirportCode: "MAD",
                #Date: "2016-05-05",
                #Time: "23:10",
                #AirportName: "Madrid Adolfo Suárez International Airport"
              #},
              #MarketingCarrier: {
                #AirlineID: "FA",
                #Name: "Kronos Air",
                #FlightNumber: "890"
              #},
              #OperatingCarrier: {
                #AirlineID: "FA",
                #Name: "Kronos Air",
                #FlightNumber: "890"
              #},
              #Equipment: {
                #AircraftCode: "31F",
                #Name: "321 - AIRBUS INDUSTRIE A321 JET"
              #},
              #ClassOfService: {
                #Code: "M"
              #},
              #FlightDetail: {
                #FlightDuration: {
                  #Value: "PT3H5M"
                #}
              #}
            #}
          #}
        #]
      #}
    #}}

    #setup do
      #@ndc_client = NDCClient::Base.new(@@ndc_config)
    #end

    #test "SeatAvailability request raises Processing error" do
      #assert_raises(NDCClient::NDCErrors::UnknownNDCProcessingError) {
        #@@ndc_response = @ndc_client.request(:SeatAvailability, invalid_query_params)
      #}
    #end

  #end

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
            DepartureCode: "SXF",
            ArrivalCode: "MAD"
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
                AirportCode: "SXF",
                Date: "2016-03-01",
                Time: "12:00"
              },
              Arrival: {
                AirportCode: "FRA",
                Date: "2016-03-01",
                Time: "13:10",
                AirportName: "Frankfurt International Airport"
              },
              MarketingCarrier: {
                AirlineID: "FA",
                Name: "Kronos Air",
                FlightNumber: "809"
              },
              OperatingCarrier: {
                AirlineID: "FA",
                Name: "Kronos Air",
                FlightNumber: "809"
              },
              Equipment: {
                AircraftCode: "31F",
                Name: "E95 EMBRAER 195 JET"
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
                Date: "2016-03-01",
                Time: "14:00",
                AirportName: "Frankfurt International Airport"
              },
              Arrival: {
                AirportCode: "MAD",
                Date: "2016-05-05",
                Time: "16:35",
                AirportName: "Madrid Adolfo Suárez International Airport"
              },
              MarketingCarrier: {
                AirlineID: "FA",
                Name: "Kronos Air",
                FlightNumber: "890"
              },
              OperatingCarrier: {
                AirlineID: "FA",
                Name: "Kronos Air",
                FlightNumber: "890"
              },
              Equipment: {
                AircraftCode: "31F",
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
      refute_empty @ndc_parsed_response.hpath('SeatAvailabilityRS/Document/MessageVersion')
    end

    test "Response includes Success element" do
      assert @ndc_parsed_response.hpath?("SeatAvailabilityRS/Success")
    end

  end

end
