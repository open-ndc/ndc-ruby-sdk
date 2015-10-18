require "net/http"
require "uri"
require "time"
require "digest/sha1"
require "logger"
require "rest-client"

# Net::HTTP.http_logger_options = {:body => true}
# Net::HTTP.http_logger_options = {:verbose => true}

require "nokogiri"
require "nori"

require_relative "core_ext/object"
extends_path = "#{File.dirname(__FILE__)}/core_ext/*.rb"
Dir[extends_path].each {|file|
  require file
}

require_relative "version"
require_relative "ndc-client/errors"
require_relative "ndc-client/base"
require_relative "ndc-client/config"

require_relative "ndc-client/messages/base"
messages_path = "#{File.dirname(__FILE__)}/ndc-client/messages/*.rb"
Dir[messages_path].each {|file|
  require file
}
