$LOAD_PATH.unshift File.dirname(__FILE__) unless 
  $LOAD_PATH.include? File.dirname(__FILE__)
require 'spec_helper'

describe "Purchase Book" do
  before :each do
    goto ''   
  end
  it 'add a book' do
    @browser.link(:href, 'http://localhost:3000/store/add_to_cart/4').click
    @browser.div(:id, 'banner').text.should == 'Your Pragmatic Cart'
    @browser.table(:index, 1)[3][2].text.should == 'Pragmatic Project Automation'
    @browser.cell(:id, 'totalcell').text.should == '$29.95'
  end
  it 'purchase books' do
    @browser.link(:href, 'http://localhost:3000/store/add_to_cart/4').click
    @browser.link(:text, 'Continue shopping').click
    @browser.link(:href, 'http://localhost:3000/store/add_to_cart/12').click
    @browser.div(:id, 'banner').text.should == 'Your Pragmatic Cart'
    @browser.table(:index, 1)[3][2].text.should == 'Pragmatic Project Automation'
    @browser.table(:index, 1)[3][1].text.should == '1'
    @browser.table(:index, 1)[4][2].text.should == 'Pragmatic Version Control'
    @browser.table(:index, 1)[3][1].text.should == '1'
    @browser.cell(:id, 'totalcell').text.should == '$59.90'
    @browser.link(:text, 'Checkout').click
    @browser.div(:id, 'banner').text.should == 'Checkout'
    @browser.table(:index, 1)[3][2].text.should == 'Pragmatic Project Automation'
    @browser.table(:index, 1)[3][1].text.should == '1'
    @browser.table(:index, 1)[4][2].text.should == 'Pragmatic Version Control'
    @browser.table(:index, 1)[3][1].text.should == '1'
    @browser.cell(:id, 'totalcell').text.should == '$59.90'
    @browser.text_field(:id, 'order_name').set('Joe Tester')
    @browser.text_field(:id, 'order_email').set('joe.test@testmail.com')
    @browser.text_field(:id, 'order_address').set("1000 Research Blvd.\nAustin, TX")
    @browser.select_list(:id, 'order_pay_type').select('Check')
    @browser.button(:name, 'commit').click
    @browser.div(:id, 'banner').text.should == 'Pragmatic Bookshelf'
    @browser.div(:id, 'notice').text.should == 'Thank you for your order.'
  end    
end