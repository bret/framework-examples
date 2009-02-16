$LOAD_PATH.unshift File.dirname(__FILE__) unless 
  $LOAD_PATH.include? File.dirname(__FILE__)
require 'spec_helper'

describe "Add Book" do
  it "should allow a book to be added to the catalog" do
    site.reset_database
    login_page do |page|
      page.goto
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
    
    new_product_page do |page|
      page.goto
      page.populate tycoons
      page.create_button.click
    end
    
    browser.url.should == product_listing_page.full_url
    product_listing_page.show_link('The Tycoons').click
    
    browser.url.should match(/#{show_product_page.full_url}/)
    show_product_page.validate tycoons
  end
end