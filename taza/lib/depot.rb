ENV['ENVIRONMENT'] ||= "test" 
APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')) unless defined?(APP_ROOT)

require 'rubygems'
$LOAD_PATH.unshift File.expand_path(ENV['TAZA_DEV'] + '/lib') if ENV['TAZA_DEV']
require 'taza'

module Depot
  include ForwardInitialization

  class Depot < ::Taza::Site
    def page_heading
      @browser.div(:id, 'banner').text
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
