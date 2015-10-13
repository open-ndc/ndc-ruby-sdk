module NDCClient
  module Messages

    class FlightPriceRQ < Messages::Base

      def initialize(params = {})
        super(params)
      end

      def yield_core_query(data, xml)
        xml.Query {
          xml.OriginDestination {
            if data.hpath('Query/OriginDestination/0/Flight').present?
              flight1 = data.hpath('Query/OriginDestination/0/Flight')
              xml.Flight {
                xml.Departure {
                  xml.AirportCode_ flight1.hpath('Departure/AirportCode')
                  xml.Date_ flight1.hpath('Departure/Date')
                  xml.Time_ flight1.hpath('Departure/Time')
                  xml.AirportName_ flight1.hpath('Departure/AirportName')
                }
                xml.Arrival {
                  xml.AirportCode_ flight1.hpath('Arrival/AirportCode')
                  xml.Date_ flight1.hpath('Arrival/Date')
                  xml.Time_ flight1.hpath('Arrival/Time')
                  xml.AirportName_ flight1.hpath('Arrival/AirportName')
                }
                xml.MarketingCarrier {
                  xml.AirlineID_ flight1.hpath('MarketingCarrier/AirlineID')
                  xml.Name_ flight1.hpath('MarketingCarrier/Name')
                  xml.FlightNumber_ flight1.hpath('MarketingCarrier/FlightNumber')
                }
                xml.OperatingCarrier {
                  xml.AirlineID_ flight1.hpath('OperatingCarrier/AirlineID')
                  xml.Name_ flight1.hpath('OperatingCarrier/Name')
                  xml.FlightNumber_ flight1.hpath('OperatingCarrier/FlightNumber')
                }
                xml.Equipment {
                  xml.AircraftCode_ flight1.hpath('Equipment/AircraftCode')
                  xml.Name_ flight1.hpath('Equipment/Name')
                }
                xml.CabinType {
                  xml.Code_ flight1.hpath('CabinType/Code')
                  xml.Definition_ flight1.hpath('CabinType/Definition')
                }
              }
            end
            if data.hpath('Query/OriginDestination/1/Flight').present?
              flight2 = data.hpath('Query/OriginDestination/1/Flight')
              xml.Flight {
                xml.Departure {
                  xml.AirportCode_ flight2.hpath('Departure/AirportCode')
                  xml.Date_ flight2.hpath('Departure/Date')
                  xml.Time_ flight2.hpath('Departure/Time')
                  xml.AirportName_ flight2.hpath('Departure/AirportName')
                }
                xml.Arrival {
                  xml.AirportCode_ flight2.hpath('Arrival/AirportCode')
                  xml.Date_ flight2.hpath('Arrival/Date')
                  xml.Time_ flight2.hpath('Arrival/Time')
                  xml.AirportName_ flight2.hpath('Arrival/AirportName')
                }
                xml.MarketingCarrier {
                  xml.AirlineID_ flight2.hpath('MarketingCarrier/AirlineID')
                  xml.Name_ flight2.hpath('MarketingCarrier/Name')
                  xml.FlightNumber_ flight2.hpath('MarketingCarrier/FlightNumber')
                }
                xml.OperatingCarrier {
                  xml.AirlineID_ flight2.hpath('OperatingCarrier/AirlineID')
                  xml.Name_ flight2.hpath('OperatingCarrier/Name')
                  xml.FlightNumber_ flight2.hpath('OperatingCarrier/FlightNumber')
                }
                xml.Equipment {
                  xml.AircraftCode_ flight2.hpath('Equipment/AircraftCode')
                  xml.Name_ flight2.hpath('Equipment/Name')
                }
                xml.CabinType {
                  xml.Code_ flight2.hpath('CabinType/Code')
                  xml.Definition_ flight2.hpath('CabinType/Definition')
                }
              }
            end
          }
        }
      end

    end

  end
end
