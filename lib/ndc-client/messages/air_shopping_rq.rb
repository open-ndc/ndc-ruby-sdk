module NDCClient
  module Messages

    class AirShoppingRQ < Messages::Base

      def initialize(params = {})
        super (params)
        data = @data

        @message = Nokogiri::XML::Builder.new {|xml|
                  xml.AirShoppingRQ(@namespaces) {
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
                    xml.Travelers {
                      xml.Traveler {
                        xml.AnonymousTraveler {
                          xml.PTC(Quantity: 1).text "ADT"
                        }
                      }
                    }
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
                        }
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

      # def wrap(wrapper)
      #   @message.wrap(wrapper)
      # end

      # Soapy
      # def to_xml_with_body_wrap
      #   if @wrappers
      #     @wrappers[:open] <<
      #     @message.doc.root.to_xml <<
      #     @wrappers[:close]
      #   else
      #     @message.doc.root.to_xml
      #   end
      # end

    end

  end
end
