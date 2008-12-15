require 'rubygems'
require 'taza'

module Depot
  include ForwardInitialization

  class Depot < ::Taza::Site
    def url
      config = Settings.config(@class_name)
      config[:url]
    end   
    class << self
      def reset_database
        Dir.chdir File.dirname(__FILE__) + '/../../../depot' do
          unless system 'mysql -u root -ppassword depot_development < db\product_data.sql'
            raise 'database error'
          end
        end
      end
    end
  end 
end
