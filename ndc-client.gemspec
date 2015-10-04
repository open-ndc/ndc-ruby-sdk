# -*- encoding: utf-8 -*-
require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "ndc-client"
  gem.version       = NDCClient::VERSION
  gem.license       = "MIT"
  gem.authors       = ["Jorge Díaz"]
  gem.email         = ["jorgedf@gmail.com"]
  gem.description   = %q{A Ruby wrapper for IATA's NDC}
  gem.summary       = %q{A Ruby wrapper for IATA's NDC}
  gem.homepage      = ""
  gem.files         = ["lib/ndc-client.rb"]
  gem.require_paths = ["lib"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_dependency "rest-client"
  gem.add_dependency "nokogiri"
  gem.add_dependency "nori"

  # Dev
  gem.add_development_dependency "minitest"
end
