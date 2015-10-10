require 'ostruct'

module NDCClient
  module Config
    extend self

    def self.ndc_config=(ndc_config)
      @ndc_config ||= OpenStruct.new
      @ndc_config = ndc_config.deep_symbolize_keys!
    end

    def self.ndc_config
      @ndc_config
    end

    def valid?
      @ndc_config[:Document] && @ndc_config[:Party]
    end

  end
end
