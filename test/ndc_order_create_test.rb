require 'test_helper'

class NDCOrderCreateTest < Test::Unit::TestCase
  extend Minitest::Spec::DSL

  describe "Sends an valid OrderCreate request" do

    ndc_config = YAML.load_file('test/config/ndc-iata-kronos.yml')
    @@ndc_client = NDCClient::Base.new(ndc_config)

    @@ndc_response = @@ndc_client.request(:AirShopping, NDCAirShoppingTest::VALID_REQUEST_PARAMS)
    @response_id = @@ndc_response.hpath('AirShoppingRS/ShoppingResponseIDs/ResponseID')

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

    @@ndc_response = @@ndc_client.request(:OrderCreate, query_params)

    test "OrderCreate response is valid" do
      assert @@ndc_client.valid_response?
    end

    test "Document version is ok" do
      refute_empty @@ndc_response.hpath('OrderCreateRS/Document')
      assert_equal @@ndc_response.hpath('OrderCreateRS/Document/ReferenceVersion'), "1.0"
    end

    test "Response includes Success element" do
      refute_nil @@ndc_response["OrderCreateRS"].has_key?("Success")
    end

  end

end
