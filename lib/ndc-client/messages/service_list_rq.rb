module NDCClient
  module Messages

    class ServiceListRQ < Messages::Base

      def initialize(params = {})
        super(params)
      end

      def yield_core_query(data, xml)
        xml.ShoppingResponseID {
          xml.ResponseID_ data.hpath('ShoppingResponseID/ResponseID')
        }
      end

    end

  end
end
