require 'spec'
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/..')
require 'depot'

Given 'my cart is empty' do
  empty_cart_page.goto
end
When /^I add to my cart (.*)$/ do | book_title |
  store_page.goto
  store_page.add_to_cart_button(book_title).click
  end
Then 'the cart is displayed' do
  @browser.url.should == your_cart_page.full_url
  site.page_heading.should == 'Your Pragmatic Cart'
end
  
Then /^the order total is (.*)$/ do | total |
  your_cart_page.total.should == total
end