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
        build_message
      end


      def build_message
        data = @data
        namespaces = @namespaces

        @message = Nokogiri::XML::Builder.new {|xml|

          xml.AirShoppingRQ(namespaces) {

            xml.Document {
              xml.Name_ "NDC AirShoppingRQ Message"
              xml.MessageVersion_ "1.1.5"
              xml.ReferenceVersion_ "1.0"
            }

            xml.Party {
              xml.Sender {
                xml.TravelAgencySender {
                  xml.Name_ data.hpath('Party/Sender/ORA_Sender/AgentUser/Name')
                  xml.IATA_Number_ data.hpath('Party/Sender/ORA_Sender/AgentUser/IATA_Number')
                  xml.AgencyID_ data.hpath('Party/Sender/ORA_Sender/AgentUser/AgentUserID')
                }
              }
              xml.Participants {
                xml.Participant {
                  xml.AggregatorParticipant( SequenceNumber: 1){
                    xml.Name_ data.hpath('Participants/Participant/AggregatorParticipant/Name')
                    xml.AggregatorID_ data.hpath('Participants/Participant/AggregatorParticipant/AggregatorID')
                  }
                }
              }
            }

            yield_core_query(data, xml)

            xml.Travelers {
              xml.Traveler {
                xml.AnonymousTraveler {
                  xml.PTC(Quantity: 1).text "ADT"
                }
              }
            }

            xml.PointOfSale {
              xml.Location {
                xml.CountryCode_ data.hpath('PointOfSale/Location/CountryCode')
                xml.CityCode_ data.hpath('PointOfSale/Location/CityCode')
              }
              xml.RequestTime(Zone: data.hpath('PointOfSale/RequestTime/Zone')).text data.hpath('PointOfSale/RequestTime')
              xml.TouchPoint {
                xml.Device {
                  xml.Code_ data.hpath('PointOfSale/TouchPoint/Device/Code')
                  xml.Definition_ data.hpath('PointOfSale/TouchPoint/Device/Definition')
                  xml.Position {
                    xml.Latitude_ data.hpath('PointOfSale/TouchPoint/Position/Latitude')
                    xml.Longitude_ data.hpath('PointOfSale/TouchPoint/Position/Longitude')
                    xml.NAC_ data.hpath('PointOfSale/TouchPoint/Position/NAC')
                  }
                }
                xml.Event data.hpath('PointOfSale/TouchPoint/Event')
              }
            }

            # Missing Preferences Block - TEMPORARY FIX FOR JRT!
            xml.Preference {
              xml.AirlinePreferences {
                xml.Airline {
                  xml.AirlineID_ data.hpath('Preference/AirlinePreferences/Airline/AirlineID')
                }
              }
              xml.FarePreferences {
                xml.Types {
                  xml.Type {
                    xml.Code_ data.hpath('Preference/FarePreferences/Types/Type/Code')
                  }
                }
              }
              xml.CabinPreferences {
                xml.CabinType {
                  xml.Code_ data.hpath('Preference/CabinPreferences/CabinType/Code')
                  xml.Definition_ data.hpath('Preference/CabinPreferences/CabinType/Definition')
                }
              }
            }

            xml.Parameters {
              xml.CurrCodes {
                xml.CurrCode_ data.hpath('Parameters/CurrCodes/CurrCode')
              }
            }

            # } # TEMPORARY FIX FOR JRT!
            xml.Metadata {
              xml.Other {
                xml.OtherMetadata {
                  xml.LanguageMetadatas {
                    xml.LanguageMetadata(MetadataKey: "Display"){
                      xml.Application_ "Display"
                      xml.Code_ISO_ "en"
                    }
                  }
                }
              }
            }
          }

        }
      end


      def to_xml
        @message.doc.root.to_xml
      end


    end
  end
end
