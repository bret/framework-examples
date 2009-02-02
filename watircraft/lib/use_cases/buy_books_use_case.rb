# by Marek J and Bret Pettichord
# Demonstrate's Marek's approach to defining use case classes.

$LOAD_PATH << (File.dirname(__FILE__) + '/..')
require 'depot'

class BuyBooks
  @@scenario = [
    :find_book,
    :add_to_cart,
    :verify_total,
    :checkout,
    :enter_my_details,
    :complete_purchase
  ]
  
  def run
    @scenario.each do |task|
      self.send task
    end
  end

  attr_accessor :books
  def initialize 
    @scenario = @@scenario
    @books = {:title => 'The Tycoons'}
    @site = Depot::Depot.new
  end
  
  def find_book   
    @site.store_page.goto
  end
  def add_to_cart
    @site.browser.link(:href, @site.url + '/store/add_to_cart/4').click
  end
  def verify_total
  end
  def checkout
  end
  def enter_my_details
  end
  def complete_purchase
    @site.browser.close
  end
end 

use_case = BuyBooks.new
use_case.run 
