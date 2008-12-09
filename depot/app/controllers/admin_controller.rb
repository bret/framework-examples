#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
# The administration functions allow authorized users
# to add, delete, list, and edit products. The class
# was initially generated from a scaffold but has since been
# modified, so do not regenerate.
#
# Only logged-in administrators can use the actions here. See
# Application.authorize for details.
#
# See also: Product

class AdminController < ApplicationController

  before_filter :authorize

  # An alias for #list, listing all current products.
  def index
    list
    render_action 'list'
  end

  # List all current products.
  def list
    @product_pages, @products = paginate :product, :per_page => 10
  end

  # Show details of a particular product.
  def show
    @product = Product.find(@params[:id])
  end

  # Initiate the creation of a new product. 
  # The work is completed in #create.
  def new
    @product = Product.new
  end

  # Get information on a new product and 
  # attempt to create a row in the database.
  def create
    @product = Product.new(@params[:product])
    if @product.save
      flash['notice'] = 'Product was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  # Initiate the editing of an existing product. 
  # The work is completed in #update.
  def edit
    @product = Product.find(@params[:id])
  end

  # Update an existing product based on values	
  # from the form.
  def update
    @product = Product.find(@params[:id])
    if @product.update_attributes(@params[:product])
      flash['notice'] = 'Product was successfully updated.'
      redirect_to :action => 'show', :id => @product
    else
      render_action 'edit'
    end
  end

	# Destroy a particular product.
  def destroy
    Product.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end

  # Ship a number of products. This action normally dispatches
  # back to itself. Each time it first looks for orders that
  # the user has marked to be shipped and ships them. It then
  # displays an updated list of orders still awaiting shipping.
  #
  # The view contains a checkbox for each pending order. If the
  # user selects the checkbox to ship the product with id 123, then
  # this method will see <tt>things_to_ship[123]</tt> set to "yes".
  def ship
    count = 0
    if things_to_ship = params[:to_be_shipped]
      count = do_shipping(things_to_ship)
      if count > 0
        count_text = pluralize(count, "order")
        flash.now[:notice] = "#{count_text} marked as shipped"
      end
    end
    @pending_orders = Order.pending_shipping
  end

  private

  def do_shipping(things_to_ship)
    count = 0
    things_to_ship.each do |order_id, do_it|
      if do_it == "yes"
        order = Order.find(order_id)
        order.mark_as_shipped
        order.save
        count += 1
      end
    end
    count
  end

  def pluralize(count, noun)
    case count
    when 0: "No #{noun.pluralize}"
    when 1: "One #{noun}"
    else    "#{count} #{noun.pluralize}"
    end
  end
end
