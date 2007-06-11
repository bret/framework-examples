#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
require File.dirname(__FILE__) + '/../test_helper'
require 'admin_controller'

# Re-raise errors caught by the controller.
class AdminController; def rescue_action(e) raise e end; end

class AdminControllerTest < Test::Unit::TestCase
  fixtures :products

  def setup
    @controller = AdminController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
  end

  def test_index
    process :index
    assert_rendered_file 'list'
  end

  def test_list
    process :list
    assert_rendered_file 'list'
    assert_template_has 'products'
  end

  def test_show
    process :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'product'
    assert_valid_record 'product'
  end

  def test_new
    process :new
    assert_rendered_file 'new'
    assert_template_has 'product'
  end

  def test_create
    num_products = Product.find_all.size

    process :create, 'product' => { }
    assert_redirected_to :action => 'list'

    assert_equal num_products + 1, Product.find_all.size
  end

  def test_edit
    process :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'product'
    assert_valid_record 'product'
  end

  def test_update
    process :update, 'product' => { 'id' => 1 }
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Product.find(1)

    process :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      product = Product.find(1)
    }
  end
end
