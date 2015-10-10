module NDCClient
  module Messages
    class Base

      NDC_CONFIG_BLOCKS = [:Document, :Party, :Participants, :Preference, :Parameters, :Metadata]
      NDC_PARAMS_BLOCKS = [:CoreQuery, :Travelers, :PointOfSale, :Preference, :Parameters]

      def initialize(params)
        @timestamp = Time.now.utc.iso8601
        @token = Digest::SHA1.hexdigest @timestamp
        @version = '1.1.5'
        @transaction_identifier = 'TR-00000'

        @namespaces = {
          'xmlns': "http://www.iata.org/IATA/EDIST",
          'xmlns:xsi': "http://www.w3.org/2001/XMLSchema-instance",
          'xsi:schemaLocation': "http://www.iata.org/IATA/EDIST ../AirShoppingRQ.xsd",
          'EchoToken': @token,
          'TimeStamp': @timestamp,
          'Version': @version,
          'TransactionIdentifier': @transaction_identifier
        }

        # Config & params merge params (config << params)
        @ndc_config = Config.ndc_config.keep_if{|k,_| NDC_CONFIG_BLOCKS.include?(k)} if Config.valid?
        @params = params.keep_if{|k,_| NDC_PARAMS_BLOCKS.include?(k)} if params
        @data = (@ndc_config || {}).merge(@params)
      end

    end
  end
end
