#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---

require File.dirname(__FILE__) + '/../test_helper'


class CartTest < Test::Unit::TestCase


  fixtures :products
  # . . .

  
  def test_add_product
    cart = Cart.new
    assert_equal(0.0, cart.total_price)
    assert_equal(0, cart.items.size)

    p1 = Product.find(1)  # $12.34
    p2 = Product.find(2)  # $23.45

    cart.add_product(p1)
    assert_equal(p1.price, cart.total_price)
    assert_equal(1, cart.items.size)

    cart.add_product(p2)
    assert_equal(p1.price + p2.price, cart.total_price)
    assert_equal(2, cart.items.size)

    # Insert of duplicate should increase price, but not item count
    cart.add_product(p1)
    assert_equal(2*p1.price + p2.price, cart.total_price)
    assert_equal(2, cart.items.size)

    cart.add_product(p2)
    assert_equal(2*p1.price + 2*p2.price, cart.total_price)
    assert_equal(2, cart.items.size)
  end
end

