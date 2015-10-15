module NDCClient
  module Messages

    class ServiceListRQ < Messages::Base

      def initialize(params = {})
        super(params)
      end

      def yield_core_query(data, xml)
        xml.ShoppingResponseIDs {
          xml.ResponseID_ data.hpath('ShoppingResponseIDs/ResponseID')
        }
      end

    end

  end
end
