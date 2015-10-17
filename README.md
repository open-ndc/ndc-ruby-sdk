# NDC Ruby SDK

This is a Ruby gem that wrapps any NDC-compliant API.
It's host-agnostic and quite flexible-through-configuration so that it can point any NDC host and using several routig/wrapping level protocols, such as SOAP or REST.

## Installation

Add this to your Gemfile:

    gem "ndc-client", :git => 'https://github.com/iata-ndc/ndc-ruby-sdk'

Then `bundle`

## Usage

Get a valid developer key at [IATA NDC Developer Portal](http://ndc.developer.iata.org/).

1. Require the library somewhere in your loading files

    `require 'ndc-client'`

2. Create a client instance using a valid NDC config

YAML config:

```
label: KRO

rest:
  url: http://iata.api.mashery.com/kronos/api
  headers:
    Accept: application/xml
    Content-Type: application/xml
    Authorization-Key: xxxxxxxxxxxxxxxxx

ndc:
  Document:
    Name: NDC Wrapper
    ReferenceVersion: "1.0"
  Party:
    Sender:
      ORA_Sender:
        AirlineID: C9
        Name: Kronos Air
        AgentUser:
          Name: Travel Wadus
          Type: TravelManagementCompany
          PseudoCity: A4A
          AgentUserID: travelwadus
          IATA_Number: "00000001"
  Participants:
    Participant:
      AggregatorParticipant:
        Name: Wadus NDC Gateway
        AggregatorID: WAD-00000
  Parameters:
    CurrCodes:
      CurrCode: EUR
  Preference:
    AirlinePreferences:
      Airline:
        AirlineID: C9
    FarePreferences:
      FarePreferences:
        Types:
          Type:
            Code: '759'
    CabinPreferences:
      CabinType:
        Code: M
        Definition: Economy/coach discounted
```

Request example

```
config = YAML.load_file('config/ndc.yml')
ndc_client = NDCClient::Base.new(config)
query_params = {departure_airport_code: 'JFK', arrival_airport_code: 'LHR', departure_date: '2015-09-01'}
ndc_response = ndc_client.request(:AirShopping, query_params)
```

This should deliver a valid set of NDC Offers if the config is OK.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
