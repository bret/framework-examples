#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
require File.dirname(__FILE__) + '/../test_helper'

class OrderTest < Test::Unit::TestCase
  fixtures :orders

  def setup
    @order = Order.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Order,  @order
  end
end
