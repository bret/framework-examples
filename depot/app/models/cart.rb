#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
# A Cart consists of a list of LineItem objects and a current
# total price. Adding a product to the cart will either add a
# new entry to the list or increase the quantity of an existing
# item in the list. In both cases the total price will 
# be updated.
#
# Class Cart is a model but does not represent information
# stored in the database. It therefore does not inherit from
# ActiveRecord::Base.

class Cart

  # An array of LineItem objects
  attr_reader :items

  # The total price of everything added to this cart
  attr_reader :total_price
  
  # Create a new shopping cart. Delegates this work to #empty!
  def initialize
    empty!
  end

  # Add a product to our list of items. If an item already
  # exists for that product, increase the quantity
  # for that item rather than adding a new item.
  def add_product(product)
    item = @items.find {|i| i.product_id == product.id}
    if item
      item.quantity += 1
    else
      item = LineItem.for_product(product)
      @items << item
    end
    @total_price += product.price
  end

  # Empty the cart by resetting the list of items
  # and zeroing the current total price.
  def empty!
    @items = []
    @total_price = 0.0
  end
end 
