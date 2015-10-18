#!/usr/bin/env rake
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require "bundler/gem_tasks"
require "rake/testtask"
require 'minitest/autorun'
require "./lib/ndc-client"

Rake::TestTask.new(:test) do |test|
  test.ruby_opts = ["-rubygems"] if defined? Gem
  test.libs << "test"
  test.test_files = FileList['test/*test.rb']
end
