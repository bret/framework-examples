require 'spec'
require 'lib/spreadsheet'

TESTFILE = 'examples/sample1.xls'

describe "Book Initialization" do
  it 'should populate the Excel Constants' do
    # Do this test first or the constants get loaded by Book.new
    XLS::ExcelConst.constants.should == []
    book = XLS::Book.new(TESTFILE)
    XLS::ExcelConst.constants.should_not == []
  end
  it 'should fail if file not specified' do
    lambda {
      book = XLS::Book.new()
     }.should raise_error
  end
  it 'should fail if file not found' do
    lambda {
      book = XLS::Book.new('examples/invalid_file_name')
     }.should raise_error
  end
  it 'should initialize properly with valid filename' do
    lambda {
      book = XLS::Book.new(TESTFILE)
     }.should_not raise_error
  end
  it 'should have default options set' do
    book = XLS::Book.new(TESTFILE)
    book.visible.should be_false
    book.continue.should be_false
  end
  it 'should handle passed options' do
    book = XLS::Book.new(TESTFILE, {:continue => 'test'})
    book.visible.should be_false
    book.continue.should == 'test'
  end
  it 'should raise error for invalid options' do
    lambda {
      book = XLS::Book.new(TESTFILE, {:unsupportedoption => true} )
    }.should raise_error()
  end
  it 'should have have a method for returning the filename' do
    book = XLS::Book.new(TESTFILE)
    book.filename.should == TESTFILE
  end
  it 'should return an ole_object for the workbook' do
    book = XLS::Book.new(TESTFILE)
    book.ole_object.class.should == WIN32OLE
  end
end

