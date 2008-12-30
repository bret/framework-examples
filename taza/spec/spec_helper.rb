ENV['TAZA_ENV'] = "isolation" if ENV['TAZA_ENV'].nil?
require 'rubygems'
require 'spec'
require 'mocha'

lib_paths = [File.expand_path("#{File.dirname(__FILE__)}/../lib/sites")]
lib_paths << ENV['TAZA_DEV'] + 'lib' if ENV['TAZA_DEV']
lib_paths.each do |lib_path|
  $LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)
end

Spec::Runner.configure do |config|
  config.mock_with :mocha
end