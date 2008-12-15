
require 'spec/spec_helper'
require 'depot'

describe "Depot Application" do
  before do
    Depot::Depot.reset_database
  end
  it "should allow a book to be added to the catalog" do
    Depot.new do |depot|
      depot.login_flow :name => 'dave', :password => 'secret'
 
      # not sure how to do this with reference to url in depot.yml
      depot.browser.goto 'http://localhost:3000/admin/new'
      depot.new_product_page do |page|
        page.title.set 'The Tycoons'
        page.description.set 'How Andrew Carnegie, John D. Rockefeller, Jay Gould, and J. P. Morgan Invented the American Supereconomy'
        page.image_url.set 'http://ecx.images-amazon.com/images/I/51qobzUJkdL._BO2,204,203,200_PIsitb-sticker-arrow-click,TopRight,35,-76_AA240_SH20_OU01_.jpg'
        page.price.set '16.00'
        page.create_button.click
      end
    end
  end
end