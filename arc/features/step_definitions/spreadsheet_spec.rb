require 'spec'
$LOAD_PATH << File.dirname(__FILE__)
require 'spreadsheet'

describe 'interface to testdata in a spreadsheet' do
  def test_data_for name
    TestData.new :file => File.dirname(__FILE__) + '/../testdata.ods', 
      :sheet => 'Products', :name => name
  end
  before :all do
    @tycoons = test_data_for 'The Tycoons'
    @building = test_data_for 'The Timeless Way of Building'
  end
  it 'should have a title' do
    @tycoons.keys.should include(:title)
  end
  it 'should allow access to data' do
    @tycoons[:title].should == 'The Tycoons'
  end
  it 'should allow access to numeric data' do
    @tycoons[:price].should == '16.0'
  end
  it 'should raise a meaningful error when a key is not in the data' do
    lambda{@tycoons[:nosuchkey]}.should raise_error(KeyNotFound)
  end
  it 'should use underscores instead of spaces in keys' do
    @tycoons[:image_url].should =~ Regexp.new('^http://ecx.images-amazon.com/images')
  end
  it 'should allow access to a second record' do
    @building[:title].should == 'The Timeless Way of Building'
  end
end