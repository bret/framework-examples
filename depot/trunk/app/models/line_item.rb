#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
# Line items tie products to orders (and before that, to carts).
# Because the price of a product may change after an order is placed, 
# the line item contains a copy of the product price at the time
# it was created.

class LineItem < ActiveRecord::Base

  belongs_to :product
  belongs_to :order

  # Return a new LineItem given a Product.
  def self.for_product(product)
    item = self.new
    item.quantity   = 1
    item.product    = product
    item.unit_price = product.price
    item
  end
end
