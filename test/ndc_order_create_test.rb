require_relative 'test_helper'

class NDCOrderCreateTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an valid OrderCreate request" do

    setup do
      @ndc_client = NDCClient::Base.new(@@ndc_config)
      @ndc_response = @ndc_client.request(:AirShopping, NDCAirShoppingTest::VALID_REQUEST_PARAMS)
      if @ndc_response.valid?
        @response_id = @ndc_response.parsed_response.hpath('AirShoppingRS/ShoppingResponseIDs/ResponseID')
      else
        raise
      end
    end


    query_params = {
      Query: {

        Passengers: [
          {
            Passenger: {
              _ObjectKey: "PAX1",
              PTC: {
                _Quantity: "1",
                __text: "ADT"
              },
              ResidenceCode: "US",
              Age: {
                BirthDate: "1989-09-09"
              },
              Name: {
                Surname: "Yadav",
                Given: "Mithalesh",
                Title: "MR",
                Middle: "Middle"
              },
              ProfileID: "123",
              Contacts: [
                {
                  Contact: {
                    EmailContact: {
                      Address: "mithalesh@jrtechnologies.com"
                    }
                  }
                },
                {
                  Contact: {
                    PhoneContact: {
                      Application: "Emergency",
                      Number: "9867236088"
                    }
                  }
                },
                {
                  Contact: {
                    AddressContact: {
                      Application: "AddressAtOrigin",
                      Street: "22 Main Street",
                      CityName: {
                        CityCode: "FRA"
                      },
                      PostalCode: "14201",
                      CountryCode: "DE"
                    }
                  }
                }
              ],
              # },
              FQTVs: {
                FQTV_ProgramCore: {
                  FQTV_ProgramID: "kR",
                  ProviderID: "KR",
                  Account: {
                      Number: "992227471658222"
                  }
                }
              },
              Gender: "Male",
              PassengerIDInfo: {
                FOID: {
                  Type: "PP",
                  ID: "333444666"
                }
              }
            }
          }
        ],

        OrderItems: {
          ShoppingResponse: {
            Owner: "C9",
            ResponseID: @response_id,
            Offers: [
              {
                Offer: {
                  OfferID: {
                    _Owner: "C9",
                    __text: "1"
                  },
                  OfferItems: [
                    {
                      OfferItem: {
                        OfferItemID: {
                          _Owner: "C9",
                          __text: "1#M#108191383#108215274"
                        },
                        Passengers: [
                          PassengerReference: "PAX1"
                        ],
                        AssociatedServices: [
                          {
                            AssociatedService: {
                              ServiceID: {
                                _Owner: "C9",
                                __text: "SV1"
                              }
                            }
                          },
                          {
                            AssociatedService: {
                              ServiceID: {
                                _Owner: "C9",
                                __text: "SV2"
                              }
                            }
                          }
                        ]
                      }
                    },
                    {
                      OfferItem: {
                        OfferItemID: {
                          _Owner: "C9",
                          __text: "2#M#108191383#108215274"
                        },
                        Passengers: [
                          PassengerReference: "PAX2"
                        ],
                        AssociatedServices: [
                          {
                            AssociatedService: {
                              ServiceID: {
                                _Owner: "C9",
                                __text: "SV1"
                              }
                            }
                          },
                          {
                            AssociatedService: {
                              ServiceID: {
                                _Owner: "C9",
                                __text: "SV2"
                              }
                            }
                          }
                        ]
                      }
                    }
                  ]
                }
              }
            ]
          }
        },


        Payments: [
          {
        		Payment: {
      				Method: {
    						PaymentCard: {
  								CardCode: "MC",
  								CardNumber: "1111222233334444",
  								SeriesCode: "584",
  								EffectiveExpireDate: {
  									Effective: "0322"
  								}
    						}
      				},
      				Amount: {
    						_Taxable: "true",
    						__text: "201987"
      				},
      				Payer: {
    						Name: {
  								Surname: "Mickey",
  								Given: "Mouse"
    						},
    						Contacts: [
  								{
                    Contact: {
    									AddressContact: {
    										Street: "22 Main Street",
    										CityName: {
    											CityCode: "FRA"
    										},
    										PostalCode: "14201",
    										CountryCode: "DE"
    									}
                    }
                  },
                  {
                    Contact: {
    									EmailContact: {
    										Address: "mithalesh@jrtechnologies.com"
    									}
                    }
  								}
    						]
      				}
        		}
          }

        ]
      }

    }

    # Test disabled until full server compliancy
    # @@ndc_response = @ndc_client.request(:OrderCreate, query_params)
    #
    # test "OrderCreate response is valid" do
    #   assert @ndc_client.valid?
    # end
    #
    # test "MessageVersion is ok" do
    #   refute_empty @@ndc_response.hpath('OrderCreateRS/Document')
    #   assert_equal @@ndc_response.hpath('OrderCreateRS/Document/MessageVersion'), "15.2"
    # end
    #
    # test "Response includes Success element" do
    #   assert @@ndc_response.hpath?("OrderCreateRS/Success")
    # end

  end

end
