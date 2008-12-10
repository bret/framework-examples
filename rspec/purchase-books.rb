require 'spec'  
require 'watir'

describe 'depot tests' do
  def select_project_automation
    @b.link(:href, 'http://localhost:3000/store/add_to_cart/4').click
  end
  before :each do
    @b = Watir::IE.start_process('http://localhost:3000/store/empty_cart')
  end
  after :each do
    @b.close
  end
  it 'add a book' do
    select_project_automation
    @b.div(:id, 'banner').text.should == 'Your Pragmatic Cart'
    @b.table(:index, 1)[3][2].text.should == 'Pragmatic Project Automation'
    @b.cell(:id, 'totalcell').text.should == '$29.95'
  end
  it 'purchase books' do
    @b.link(:href, 'http://localhost:3000/store/add_to_cart/4').click
    @b.link(:text, 'Continue shopping').click
    @b.link(:href, 'http://localhost:3000/store/add_to_cart/12').click
    @b.div(:id, 'banner').text.should == 'Your Pragmatic Cart'
    @b.table(:index, 1)[3][2].text.should == 'Pragmatic Project Automation'
    @b.table(:index, 1)[3][1].text.should == '1'
    @b.table(:index, 1)[4][2].text.should == 'Pragmatic Version Control'
    @b.table(:index, 1)[3][1].text.should == '1'
    @b.cell(:id, 'totalcell').text.should == '$59.90'
    @b.link(:text, 'Checkout').click
    @b.div(:id, 'banner').text.should == 'Checkout'
    @b.table(:index, 1)[3][2].text.should == 'Pragmatic Project Automation'
    @b.table(:index, 1)[3][1].text.should == '1'
    @b.table(:index, 1)[4][2].text.should == 'Pragmatic Version Control'
    @b.table(:index, 1)[3][1].text.should == '1'
    @b.cell(:id, 'totalcell').text.should == '$59.90'
    @b.text_field(:id, 'order_name').set('Joe Tester')
    @b.text_field(:id, 'order_email').set('joe.test@testmail.com')
    @b.text_field(:id, 'order_address').set("1000 Research Blvd.\nAustin, TX")
    @b.select_list(:id, 'order_pay_type').select('Check')
    @b.button(:name, 'commit').click
    @b.div(:id, 'banner').text.should == 'Pragmatic Bookshelf'
    @b.div(:id, 'notice').text.should == 'Thank you for your order.'
  end
end