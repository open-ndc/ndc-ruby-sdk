# NDC Ruby SDK

This is a Ruby gem that wrapps any NDC-compliant API.
It's host-agnostic and somehow flexible-through-configuration so that it can point any NDC host and using several routig/wrapping level protocols, such as SOAP or REST. 

## Installation

Add this to your Gemfile:

    gem "ndc-client", :git => 'https://github.com/flyiin/ndc-ruby-sdk'

Then `bundle`

## Usage

1. Require the library

    `require 'ndc-client'`

2. Create a client instance using a valid NDC config
 
YAML config:

    provider:
        iata-code: AA
        label: American Airlines
    options:
        travelAgency:
        name: Flyiin
        agencyID: test agent
        IATA_Number: '0000XXXX'

Request example

```
config = YAML.load('config/ndc.yml')
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
