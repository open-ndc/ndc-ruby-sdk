module NDCClient
  module Messages

    class AirShoppingRQ < Messages::Base

      def initialize(params = {})
        super(params)
      end

      def yield_core_query(data, xml)
        xml.CoreQuery {
          xml.OriginDestinations {
            xml.OriginDestination {
              xml.Departure {
                xml.AirportCode_ data.hpath('CoreQuery/OriginDestinations/OriginDestination/Departure/AirportCode')
                xml.Date_ data.hpath('CoreQuery/OriginDestinations/OriginDestination/Departure/Date')
              }
              xml.Arrival {
                xml.AirportCode_ data.hpath('CoreQuery/OriginDestinations/OriginDestination/Arrival/AirportCode')
                xml.Date_ data.hpath('CoreQuery/OriginDestinations/OriginDestination/Arrival/Date') if data.hpath('CoreQuery/OriginDestinations/OriginDestination/Arrival/Date')
              }
              if data.hpath('CoreQuery/OriginDestinations/OriginDestination/MarketingCarrierAirline')
                xml.MarketingCarrierAirline {
                  xml.AirlineID_ data.hpath('CoreQuery/OriginDestinations/OriginDestination/MarketingCarrierAirline/AirlineID') if data.hpath('CoreQuery/OriginDestinations/OriginDestination/MarketingCarrierAirline/AirlineID').present?
                  xml.Name_ data.hpath('CoreQuery/OriginDestinations/OriginDestination/MarketingCarrierAirline/Name') if data.hpath('CoreQuery/OriginDestinations/OriginDestination/MarketingCarrierAirline/Name').present?
                }
              end
            }
          }
        }
      end

    end

  end
end
