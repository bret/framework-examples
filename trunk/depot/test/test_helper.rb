#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
ENV["RAILS_ENV"] = "test"
require File.dirname(__FILE__) + "/../config/environment"
require 'application'

require 'test/unit'
require 'active_record/fixtures'
require 'action_controller/test_process'
require 'breakpoint'

def create_fixtures(*table_names)
  Fixtures.create_fixtures(File.dirname(__FILE__) + "/fixtures", table_names)
end

Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"