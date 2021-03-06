require 'rubygems'
require 'taza'

module Depot
  include ForwardInitialization

  class Depot < ::Taza::Site
    def page_heading
      @browser.div(:id, 'banner').text
    end
    def reset_database
      Dir.chdir File.dirname(__FILE__) + '/../../../depot' do
        unless system 'mysql -u root -ppassword depot_development < db\product_data.sql'
          raise 'database error'
        end
      end
    end
  end 
end
