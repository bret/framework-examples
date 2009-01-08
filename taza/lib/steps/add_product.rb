require 'spec'
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/..')
require 'depot'

World do
  Depot::Depot.new
end
    
Given 'my cart is empty' do
  goto 'store/empty_cart'
#  empty_cart_page.goto
#  @browser.goto 'http://localhost:3000/store/empty_cart'
end
When /^I add to my cart (.*)$/ do | book_title |
  @browser.goto 'http://localhost:3000/store'
  title = @browser.h3(:text, book_title) 
  catalog_entry = title.parent
  catalog_entry.link(:class, 'addtocart').click
end
Then 'the cart is displayed' do
  @browser.div(:id, 'banner').text.should == 'Your Pragmatic Cart'
end
Then /^the order total is (.*)$/ do | total |
  @browser.cell(:id, 'totalcell').text.should == total
end