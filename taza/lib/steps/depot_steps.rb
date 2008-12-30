require 'spec'
require 'watir'
    
Given 'my cart is empty' do
  @browser = Watir::IE.find(:title, 'Pragprog Books Online Store') ||
    Watir::IE.new
  @browser.goto 'http://localhost:3000/store/empty_cart'
end
When /^i add to my cart (.*)$/ do | book_title |
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