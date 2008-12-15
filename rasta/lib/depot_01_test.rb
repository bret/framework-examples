dir = File.dirname(__FILE__)

require "#{dir}\/depot_defs"
require 'rubygems'
	
$site = "http://localhost:3000/store"

class Tests < Watir::TestCase


  include Depot_Defs

  def test_01_add_book_to_cart
    goto_site($site)
    add_book_to_cart_link("Pragmatic Project Automation")
    link_by_text_click("Continue shopping")
    add_book_to_cart_link("Pragmatic Unit Testing (C#)")
    link_by_text_click("Checkout")
    shipping_name_text_field.set'Test Order'
    pay_using("Credit Card")
  end
end
