module NDCClient
  module Messages

    class SeatAvailabilityRQ < Messages::Base

      def initialize(params = {})
        super(params)
      end

      def yield_core_query(data, xml)
        xml.Query {
          xml.OriginDestination {
            xml.OriginDestinationReferences_ data.hpath('Query/OriginDestination/OriginDestinationReferences')
          }
        }
      end

    end

  end
end
