require 'test/specs/spec_helper'

describe "Add Book" do
  before do
    Depot::Depot.reset_database
  end
  it "should allow a book to be added to the catalog" do
    Depot.new do |depot|
      depot.login_flow :name => 'dave', :password => 'secret'
 
      depot.new_product_page do |page|
        page.goto
        page.title = 'The Tycoons'
        page.description = 'How Andrew Carnegie, John D. Rockefeller, Jay Gould, and J. P. Morgan Invented the American Supereconomy'
        page.image_url = 'http://ecx.images-amazon.com/images/I/51qobzUJkdL._BO2,204,203,200_PIsitb-sticker-arrow-click,TopRight,35,-76_AA240_SH20_OU01_.jpg'
        page.price = '16.00'
        page.create_button.click
      end
    end
  end
end