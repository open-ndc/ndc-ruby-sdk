require 'minitest/autorun'
require 'test/unit'

require 'net-http-spy'
Net::HTTP.http_logger_options = {trace: true, verbose: false}

case RUBY_ENGINE
when 'ruby'
  require 'pry-byebug'
when 'jruby'
  require 'pry'
end

# Load SDK
require_relative '../lib/ndc-client'

# Load SDK Config
@@wrong_ndc_config = YAML.load_file('test/config/ndc-wrong.yml')
@@ndc_config = YAML.load_file('test/config/ndc-openndc.yml')
