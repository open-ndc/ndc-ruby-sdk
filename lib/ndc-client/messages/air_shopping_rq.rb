module NDCClient
  module Messages

    class AirShoppingRQ

      def initialize(params, options = nil, wrappers = nil)
        @travel_agency = options['travelAgency']
        @wrappers = wrappers
        @timestamp = Time.now.utc.iso8601
        @token = Digest::SHA1.hexdigest @timestamp

        @message = Nokogiri::XML::Builder.new {|xml|
                  xml.AirShoppingRQ(
                    'xmlns': "http://www.iata.org/IATA/EDIST",
                    'xmlns:xsi': "http://www.w3.org/2001/XMLSchema-instance",
                    'xsi:schemaLocation': "http://www.iata.org/IATA/EDIST ../AirShoppingRQ.xsd",
                    'EchoToken': @token,
                    'TimeStamp': @timestamp,
                    'Version': "1.1.5",
                    'TransactionIdentifier': "TRN00000"
                  ) {
                    xml.Document {
                      xml.Name_ "Ruby Wrapper AirShoppingRQ Message"
                      xml.MessageVersion_ "1.1.5"
                      xml.ReferenceVersion_ "1.0"
                    }
                    xml.Party {
                      xml.Sender {
                        xml.TravelAgencySender {
                          xml.Name_ @travel_agency['name']
                          xml.IATA_Number_ @travel_agency['IATA_Number']
                          xml.AgencyID_ @travel_agency['agencyID']
                        }
                      }
                      xml.Participants {
                        xml.Participant {
                          xml.AggregatorParticipant( SequenceNumber: 1){
                            xml.Name_ "Flyiin"
                            xml.AggregatorID_ "Flyiin AggregatorID"
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
                            xml.AirportCode_ params[:departure_airport_code]
                            xml.Date_ params[:departure_date]
                          }
                          xml.Arrival {
                            xml.AirportCode_ params[:arrival_airport_code]
                          }
                        }
                      }
                    }
                    # xml.Preferences {  # TEMPORARY FIX FOR JRT!
                    xml.Preference {
                      xml.AirlinePreferences {
                        xml.Airline {
                          xml.AirlineID_ "C9"
                        }
                      }
                      xml.FarePreferences {
                        xml.Types {
                          xml.Type {
                            xml.Code_ 759
                          }
                        }
                      }
                      xml.CabinPreferences {
                        xml.CabinType {
                          xml.Code_ "M"
                          xml.Definition_ "Economy/coach discounted"
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

      # def doc
      #   @message.doc
      # end

      # def wrap(wrapper)
      #   @message.wrap(wrapper)
      # end

      def to_xml
        @message.doc.root.to_xml
      end

      def to_xml_with_body_wrap
        if @wrappers
          @wrappers[:open] <<
          @message.doc.root.to_xml <<
          @wrappers[:close]
        else
          @message.doc.root.to_xml
        end
      end

    end

  end
end
