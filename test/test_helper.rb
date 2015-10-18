require 'minitest/autorun'
require 'test/unit'

require 'net-http-spy'

case RUBY_ENGINE
when 'ruby'
  require 'pry-byebug'
when 'jruby'
  require 'pry'
end

# Load test config
require_relative '../lib/ndc-client'
