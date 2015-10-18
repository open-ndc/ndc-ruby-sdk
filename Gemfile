source 'https://rubygems.org'

# Specify your gem's dependencies in ndc-client.gemspec

# Github
gem "nori", :git => 'https://github.com/xurde/nori'

group :test, :development do
  gem 'rake'
  gem 'net-http-spy'
end

group :test do
  gem 'test-unit'
  gem 'minitest'
end

platforms :ruby do
  group :test, :development do
    gem 'pry-byebug'
  end
end

platforms :jruby do
  group :test, :development do
    gem 'pry'
  end
end

gemspec
