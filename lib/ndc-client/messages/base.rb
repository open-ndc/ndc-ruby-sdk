module NDCClient
  module Messages
    class Base

      NDC_CONFIG_BLOCKS = [:Document, :Party, :Participants, :Preference, :Parameters, :Metadata]
      NDC_PARAMS_BLOCKS = [:CoreQuery, :Query, :ShoppingResponseIDs, :Travelers, :PointOfSale, :Preference, :Parameters, :DataList, :DataLists]

      def initialize(params)
        @method = self.class.to_s.split('::').last
        @timestamp = Time.now.utc.iso8601
        @token = Digest::SHA1.hexdigest @timestamp
        @version = '1.1.5'
        @transaction_identifier = 'TR-00000'

        @namespaces = {
          'xmlns' => "http://www.iata.org/IATA/EDIST",
          'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
          'EchoToken' => @token,
          'TimeStamp' => @timestamp,
          'Version' => @version,
          'TransactionIdentifier' => @transaction_identifier
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
        method = @method

        @message = Nokogiri::XML::Builder.new {|xml|

          xml.send(method, namespaces) {

            xml.Document {
              xml.Name_ "NDC Message"
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

            # Inserts core query data taken from the subclass
            yield_core_query(data, xml)

            xml.Travelers {
              xml.Traveler {
                xml.AnonymousTraveler {
                  xml.PTC(Quantity: 1) { xml.text "ADT" }
                }
              }
            }
            if data.hpath('PointOfSale').present?
              xml.PointOfSale {
                xml.Location {
                  xml.CountryCode_ data.hpath('PointOfSale/Location/CountryCode')
                  xml.CityCode_ data.hpath('PointOfSale/Location/CityCode')
                }
                xml.RequestTime(Zone: data.hpath('PointOfSale/RequestTime/Zone')) { xml.text data.hpath('PointOfSale/RequestTime') }
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
            end

            xml.Preferences {
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
            }

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

            if self.respond_to?(:yield_datalist)
              yield_datalist(data, xml)
            else

              if data.hpath('DataList').present?
                xml.DataList {
                  if data.hpath('DataList/OriginDestinationList').present?
                    xml.OriginDestinationList {
                      if data.hpath('DataList/OriginDestinationList/OriginDestination').present?
                        xml.OriginDestination((data.hpath('DataList/OriginDestinationList/OriginDestination/_OriginDestinationKey').present? ? {OriginDestinationKey: data.hpath('DataList/OriginDestinationList/OriginDestination/_OriginDestinationKey')} : nil )) {
                            xml.DepartureCode_ data.hpath('DataList/OriginDestinationList/OriginDestination/DepartureCode')
                            xml.ArrivalCode_ data.hpath('DataList/OriginDestinationList/OriginDestination/ArrivalCode')
                        }
                      end
                    }
                  end
                  if data.hpath('DataList/FlightSegmentList').present?
                    xml.FlightSegmentList {
                      data.hpath('DataList/FlightSegmentList').each { |fs|
                        flight_segment = fs[:FlightSegment]
                        xml.FlightSegment(SegmentKey: flight_segment.hpath('_SegmentKey')) {
                          xml.Departure {
                            xml.AirportCode_ flight_segment.hpath('Departure/AirportCode')
                            xml.Date_ flight_segment.hpath('Departure/Date')
                            xml.Time_ flight_segment.hpath('Departure/Time')
                            xml.AirportName_ flight_segment.hpath('Departure/AirportName')
                          }
                          xml.Arrival {
                            xml.AirportCode_ flight_segment.hpath('Arrival/AirportCode')
                            xml.Date_ flight_segment.hpath('Arrival/Date')
                            xml.Time_ flight_segment.hpath('Arrival/Time')
                            xml.AirportName_ flight_segment.hpath('Arrival/AirportName')
                          }
                          if flight_segment.hpath('MarketingCarrier')
                            xml.MarketingCarrier {
                              xml.AirlineID_ flight_segment.hpath('MarketingCarrier/AirlineID')
                              xml.Name_ flight_segment.hpath('MarketingCarrier/Name')
                              xml.FlightNumber_ flight_segment.hpath('MarketingCarrier/FlightNumber')
                            }
                          end
                          if flight_segment.hpath('OperatingCarrier')
                            xml.OperatingCarrier {
                              xml.AirlineID_ flight_segment.hpath('OperatingCarrier/AirlineID')
                              xml.Name_ flight_segment.hpath('OperatingCarrier/Name')
                              xml.FlightNumber_ flight_segment.hpath('OperatingCarrier/FlightNumber')
                            }
                          end
                          if flight_segment.hpath('Equipment')
                            xml.Equipment {
                              xml.AircraftCode_ flight_segment.hpath('Equipment/AircraftCode')
                              xml.Name_ flight_segment.hpath('Equipment/Name')
                            }
                          end
                          if flight_segment.hpath('CabinType')
                            xml.CabinType {
                              xml.Code_ flight_segment.hpath('CabinType/Code')
                              xml.Definition_ flight_segment.hpath('CabinType/Definition')
                            }
                          end
                          if flight_segment.hpath('ClassOfService')
                            xml.ClassOfService {
                              xml.Code_ flight_segment.hpath('ClassOfService/Code')
                            }
                          end
                        }
                      }
                    }
                  end

                  if data.hpath('DataList/FlightList').present?
                    xml.FlightList {
                      data.hpath('DataList/FlightList').each { |fl|
                        flight = fl[:Flight]
                        xml.Flight(FlightKey: flight.hpath('_FlightKey')) {
                          xml.Journey {
                            xml.Time_ flight.hpath('Journey/Time')
                          }
                        }
                      }
                    }
                  end

                }
              end
            end
          }

        }
      end


      def to_xml
        @message.doc.root.to_xml
      end


    end
  end
end
