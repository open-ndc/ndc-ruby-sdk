module NDCClient
  module Messages

    class FlightPriceRQ < Messages::Base

      def initialize(params = {})
        super(params)
      end

      def yield_core_query(data, xml)
        xml.Query {
          originDestinations = data.hpath('Query/OriginDestination')
            unless originDestinations.size.zero?
              originDestinations.each do |originDestination|
                xml.OriginDestination {
                  unless originDestination.size.zero?
                    originDestination.each do |_key, flights|
                    flights.each do |flight|
                      if flight.is_a? Hash
                        xml.Flight {
                        xml.Departure {
                          xml.AirportCode_ flight.hpath('Departure/AirportCode')
                          xml.Date_ flight.hpath('Departure/Date')
                          xml.Time_ flight.hpath('Departure/Time')
                          xml.AirportName_ flight.hpath('Departure/AirportName')
                        }
                        xml.Arrival {
                          xml.AirportCode_ flight.hpath('Arrival/AirportCode')
                          xml.Date_ flight.hpath('Arrival/Date')
                          xml.Time_ flight.hpath('Arrival/Time')
                          xml.AirportName_ flight.hpath('Arrival/AirportName')
                        }
                        xml.MarketingCarrier {
                          xml.AirlineID_ flight.hpath('MarketingCarrier/AirlineID')
                          xml.Name_ flight.hpath('MarketingCarrier/Name')
                          xml.FlightNumber_ flight.hpath('MarketingCarrier/FlightNumber')
                        }
                        xml.OperatingCarrier {
                          xml.AirlineID_ flight.hpath('OperatingCarrier/AirlineID')
                          xml.Name_ flight.hpath('OperatingCarrier/Name')
                          xml.FlightNumber_ flight.hpath('OperatingCarrier/FlightNumber')
                        }
                        xml.Equipment {
                          xml.AircraftCode_ flight.hpath('Equipment/AircraftCode')
                          xml.Name_ flight.hpath('Equipment/Name')
                        }
                        xml.CabinType {
                          xml.Code_ flight.hpath('CabinType/Code')
                          xml.Definition_ flight.hpath('CabinType/Definition')
                        }
                      }
                      end
                    end
                    end
                  end
                }
              end
            end
        }
      end

      def yield_datalist(data, xml)
        if data.hpath('DataLists').present?
          xml.DataLists {
            if data.hpath('DataLists/OriginDestinationList').present?
              xml.OriginDestinationList {
                if data.hpath('DataLists/OriginDestinationList/OriginDestination').present?
                  xml.OriginDestination( (data.hpath('DataLists/OriginDestinationList/OriginDestination/_OriginDestinationKey').present? ? {OriginDestinationKey: data.hpath('DataLists/OriginDestinationList/OriginDestination/_OriginDestinationKey')} : nil ) ) {
                      xml.DepartureCode_ data.hpath('DataLists/OriginDestinationList/OriginDestination/DepartureCode')
                      xml.ArrivalCode_ data.hpath('DataLists/OriginDestinationList/OriginDestination/ArrivalCode')
                  }
                end
              }
            end
          }
        end
      end

    end

  end
end
