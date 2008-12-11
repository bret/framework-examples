require 'spec'
require 'watir'

class Depot
  class << self
    def reset_database
      Dir.chdir File.dirname(__FILE__) + '/../../../depot' do
        unless system 'mysql -u root -ppassword depot_development < db\product_data.sql'
          raise 'database error'
        end
      end
    end
    def initialize_browser
      browser = Watir::IE.find(:title, /Pragprog Books Online Store/) ||
        Watir::IE.new
      browser.speed = :fast
      browser
    end
  end
end

class NullElement
  def set x
  end
end

class NewProductPage
  include Spec::Matchers
  attr_reader :browser
  def initialize browser
    @browser = browser
  end
  
  def title
    browser.text_field(:id, 'product_title')
  end
  def description
    browser.text_field(:id, 'product_description')
  end
  def image_url
    browser.text_field(:id, 'product_image_url')
  end
  def price
    browser.text_field(:id, 'product_price')
  end
  def date_available
    NullElement.new
  end

  def create
    create_button.click
    error_box.should_not exist
  end
  def create_button
    browser.button(:value, 'Create')
  end

  def error_box
    browser.div(:id, 'errorExplanation')
  end
end

Given 'I have logged as an admin' do
  Depot.reset_database
  @browser = Depot.initialize_browser
  @browser.goto 'http://localhost:3000/login/login'
  @browser.text_field(:id => 'user_name').set 'dave'
  @browser.text_field(:id => 'user_password').set 'secret'
  @browser.button(:value => ' LOGIN ').click
  @browser.url.should == 'http://localhost:3000/login'
end

When /^I add product "(.*)" as specified in (.*)$/ do |title, file|
  @browser.goto 'http://localhost:3000/admin/list'
  @browser.link(:text => 'New product').click
  page = NewProductPage.new @browser
  data = TestData.new :file => File.dirname(__FILE__) + '/../' + file, 
    :sheet => 'Products', :name => 'The Tycoons'
  data.each {|key, value| page.send(key).set value}
  page.create
end

Then /^I can order one copy of "(.*)"$/ do |title|
end

Then 'my total will be $total' do |total|
end
