require 'test/specs/spec_helper'

describe "Add Book" do
  before do
    Depot::Depot.reset_database
  end
  it "should allow a book to be added to the catalog" do
    Depot.new do |depot|
      depot.product_listing_page.goto
      depot.browser.url.should == depot.login_page.full_url
      depot.login_page do |page|
        page.user_name = 'dave'
        page.password = 'secret'
        page.login_button.click
      end
 
      tycoons = {
        :title => 'The Tycoons',
        :description => '<P>How Andrew Carnegie, John D. Rockefeller, Jay Gould, and J. P. Morgan Invented the American Supereconomy</P>',
        :image_url => 'http://ecx.images-amazon.com/images/I/51qobzUJkdL._BO2,204,203,200_PIsitb-sticker-arrow-click,TopRight,35,-76_AA240_SH20_OU01_.jpg',
        :price => '16.0' 
      }
 
      depot.new_product_page do |page|
        page.goto
        page.populate tycoons
        page.create_button.click
      end
      
      depot.browser.url.should == depot.product_listing_page.full_url
      depot.product_listing_page.show_link('The Tycoons').click

      depot.show_product_page do |page|
        depot.browser.url.should match(Regexp.new(page.full_url))
        page.validate tycoons
      end
    end
  end
end