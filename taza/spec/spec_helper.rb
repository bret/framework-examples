ENV['TAZA_ENV'] = "isolation" if ENV['TAZA_ENV'].nil?
require 'rubygems'
require 'spec'
require 'mocha'

$LOAD_PATH.unshift File.expand_path(ENV['TAZA_DEV'] + '/lib') if ENV['TAZA_DEV']
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')

Spec::Runner.configure do |config|
  config.mock_with :mocha
end