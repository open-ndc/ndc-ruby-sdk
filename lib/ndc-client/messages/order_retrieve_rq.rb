module NDCClient
  module Messages

    class OrderRetriveRQ < Messages::Base

      def initialize(params = {})
        super(params)
      end

      def yield_core_query(data, xml)
        xml.Query {
          xml.Filters {
            xml.OrderID(Owner: data.hpath('Query/Filters/OrderID/_Owner')) { xml.text data.hpath('Query/Filters/OrderID/__text') }
          }
        }
      end

    end

  end
end
