#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
# The StoreController runs the buyer side of our store.
#
# [#index]        Display the catalog
# [#add_to_cart]  Add a selected product to the current cart
# [#display_cart] Show the contents of the cart
# [#empty_cart]   Clear out the cart
# {#checkout}     Initiate the checkout
# [#save_order]   Finalize the checkout by saving the order
class StoreController < ApplicationController

  before_filter :find_cart, :except => :index

  # Display the catalog, a list of all salable products.
  def index
    @products = Product.salable_items
  end

  # Add the given product to the current cart.
  def add_to_cart
    product = Product.find(params[:id])
    @cart.add_product(product)
    redirect_to(:action => 'display_cart')
  rescue
    logger.error("Attempt to access invalid product #{params[:id]}")
    redirect_to_index('Invalid product')
  end
  
  # Display the contents of the cart. If the cart is
  # empty, display a notice and return to the
  # catalog instead.
  def display_cart
    @items = @cart.items
    if @items.empty?
      redirect_to_index("Your cart is currently empty")
    end

    if params[:context] == :checkout
      render(:layout => false)
    end
  end

  # Remove all items from the cart
  def empty_cart
    @cart.empty!
    redirect_to_index('Your cart is now empty')
  end

  # Prompt the user for their contact details and payment method,
  # The checkout procedure is completed by the #save_order method.
  def checkout
    @items = @cart.items
    if @items.empty?
      redirect_to_index("There's nothing in your cart!")
    else
      @order = Order.new
    end
  end

  # Called from checkout view, we convert a cart into an order
  # and save it in the database.
  def save_order
    @order = Order.new(params[:order]) 
    @order.line_items << @cart.items      
    if @order.save                       
      @cart.empty!
      redirect_to_index('Thank you for your order.')
    else
      render(:action => 'checkout')          
    end
  end

  private

  # Save a cart object in the @cart variable. If we already
  # have one cached in the session, use it, otherwise create
  # a new one and add it to the session
  def find_cart
    @cart = (session[:cart] ||= Cart.new)
  end
end
