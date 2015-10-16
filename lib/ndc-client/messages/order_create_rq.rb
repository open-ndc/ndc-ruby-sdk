module NDCClient
  module Messages

    class OrderCreateRQ < Messages::Base

      def initialize(params = {})
        super(params)
      end

      def yield_core_query(data, xml)
        puts "DEBUG :: YIELDS ORDER CREATE"
        xml.Query {
          if data.hpath('Passengers').present?
            xml.Passengers {
              data.hpath('Passengers').each do |passenger|
                xml.Passenger((passenger.hpath('_ObjectKey').present? ? {ObjectKey: passenger.hpath('_ObjectKey')} : nil )) {
                  xml.PTC((passenger.hpath('PTC/_Quantity').present? ? {Quantity: passenger.hpath('PTC/_Quantity')} : nil )) { xml.text passenger.hpath('PTC/__text') }
                  xml.ResidenceCode_ passenger.hpath('ResidenceCode')
                  xml.Age {
                    xml.BirthDate_ passenger.hpath('Age/BirthDate') if passenger.hpath('PTC/Age/BirthDate').present?
                  }
                  xml.Gender_ passenger.hpath('Gender')
                  xml.Name {
                    xml.Surname_ passenger.hpath('Name/Surname')
                    xml.Given_ passenger.hpath('Name/Given')
                    xml.Title_ passenger.hpath('Name/Title')
                    xml.Middle_ passenger.hpath('Name/Middle')
                  }
                  xml.ProfileID_ passenger.hpath('ProfileID')
                  if passenger.hpath('Contacts').present?
                    passenger.hpath('Contacts').each {|contact|
                      xml.Contact{
                        xml.EmailContact {
                          xml.Address_ contact.hpath('EmailContact/Address')
                        }
                        xml.PhoneContact {
                          xml.Application_ contact.hpath('PhoneContact/Application')
                          xml.Number_ contact.hpath('PhoneContact/Number')
                        }
                        xml.AddressContact {
                          xml.Application_ contact.hpath('AddressContact/Application')
                          xml.Number_ contact.hpath('PhoneContact/Number')
                        }
                      }
                    }
                  end
                  xml.FQTVs {
                    xml.FQTV_ProgramCore {
                      xml.FQTV_ProgramID_ passenger.hpath('FQTVs/FQTV_ProgramCore/FQTV_ProgramID')
                      xml.ProviderID_ passenger.hpath('FQTVs/FQTV_ProgramCore/ProviderID')
                      xml.Account {
                        xml.Number_ passenger.hpath('FQTVs/FQTV_ProgramCore/Account/Number')
                      }
                    }
                  }
                  xml.PassengerIDInfo {
                    xml.FOID {
                      xml.Type_ passenger.hpath('PassengerIDInfo/FOID/Type')
                      xml.ID_ passenger.hpath('PassengerIDInfo/FOID/ID')
                    }
                  }
                }
              end
            }
          end


          xml.OrderItems {
            xml.ShoppingResponse {
              xml.Owner_ data.hpath('OrderItems/ShoppingResponse/Owner')
              xml.ResponseID_ data.hpath('OrderItems/ShoppingResponse/ResponseID')
              if data.hpath('OrderItems/ShoppingResponse/Offers').present?
                xml.Offers {
                  data.hpath('OrderItems/ShoppingResponse/Offers').each do |offer|
                    xml.Offer {
                      xml.OfferID((offer.hpath('OfferID/_Owner').present? ? {Owner: offer.hpath('OfferID/_Owner')} : nil)) {xml.text offer.hpath('OfferID/__text')}
                      if offer.hpath('Offer/OfferItems').present?
                        xml.OfferItems {
                          offer.hpath('Offer/OfferItems').each do |offer_item|
                            xml.OfferItem {
                              xml.OfferItemID((offer_item.hpath('OfferItemID/_Owner').present? ? {Owner: offer_item.hpath('OfferItemID/_Owner')} : nil)) {xml.text offer_item.hpath('OfferItemID/__text')}
                              if offer_item.hpath('Passengers').present?
                                xml.Passengers {
                                  offer_item.hpath('Passengers').each do |passenger|
                                    xml.PassengerReference_ passenger.hpath('PassengerReference')
                                  end
                                }
                              end
                              if offer_item.hpath('AssociatedServices').present?
                                xml.AssociatedServices {
                                  offer_item.hpath('AssociatedServices').each do |associated_service|
                                    xml.AssociatedService {
                                      xml.ServiceID((associated_service.hpath('ServiceID/_Owner').present? ? {Owner: associated_service.hpath('ServiceID/_Owner')} : nil)) {xml.text associated_service.hpath('ServiceID/__text')}
                                    }
                                  end
                                }
                              end
                            }
                          end
                        }
                      end
                    }
                  end
                }
              end
            }
          }




          xml.Payments {
            data.hpath('Payments').each do |payment|
              xml.Payment {
                xml.Method {
                  xml.PaymentCard {
                    xml.CardCode_ payment.hpath('Method/PaymentCard/CardCode')
                    xml.CardNumber_ payment.hpath('Method/PaymentCard/CardNumber')
                    xml.SeriesCode_ payment.hpath('Method/PaymentCard/SeriesCode')
                    xml.EffectiveExpireDate {
                      xml.Effective_ payment.hpath('Method/PaymentCard/EffectiveExpireDate/Effective')
                    }
                    xml.Amount((payment.hpath('Amount/_Taxable').present? ? {Taxable: payment.hpath('Amount/_Taxable')} : nil)) {xml.text payment.hpath('Amount/__text')}
                    xml.Payer {
                      xml.Name_ payment.hpath('Payer/Name')
                      xml.Surname_ payment.hpath('Amount/Surname')
                    }
                    if payment.hpath('Contacts').present?
                      xml.Contacts {
                        payment.hpath('Contacts').each do |contact|
                          xml.Contact {
                            xml.AddressContact {
                              xml.Street_ contact.hpath('AddressContact/Street')
                              xml.CityName {
                                xml.CityCode_ contact.hpath('AddressContact/CityName/CityCode')
                              }
                              xml.PostalCode_ contact.hpath('AddressContact/PostalCode')
                              xml.CountryCode_ contact.hpath('AddressContact/CountryCode')
                              xml.EmailContact {
                                xml.Address_ contact.hpath('AddressContact/EmailContact/Address')
                              }
                            }
                          }
                        end
                      }
                    end
                  }
                }
              }
            end
          }
        }
      end

    end

  end
end
