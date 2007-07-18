TOPDIR = File.join(File.dirname(__FILE__), '..')
$LOAD_PATH.unshift TOPDIR

require 'spec'
require 'lib/spreadsheet'

puts `pwd`
TESTFILE = TOPDIR + '/examples/spreadsheet_parsing.xls'

describe "Book Initialization" do
  it 'should populate the Excel Constants' do
    # Do this test first or the constants get loaded by Book.new
    Spreadsheet::ExcelConst.constants.should == []
    book = Spreadsheet::Book.new(TESTFILE)
    Spreadsheet::ExcelConst.constants.should_not == []
  end
  it 'should fail if file not specified' do
    lambda {
      book = Spreadsheet::Book.new()
     }.should raise_error
  end
  it 'should fail if file not found' do
    lambda {
      book = Spreadsheet::Book.new('examples/invalid_file_name')
     }.should raise_error
  end
  it 'should initialize properly with valid filename' do
    lambda {
      book = Spreadsheet::Book.new(TESTFILE)
     }.should_not raise_error
  end
  it 'should have default options set' do
    book = Spreadsheet::Book.new(TESTFILE)
    book.visible.should be_false
    book.continue.should be_false
  end
  it 'should handle passed options' do
    book = Spreadsheet::Book.new(TESTFILE, {:continue => 'test'})
    book.visible.should be_false
    book.continue.should == 'test'
  end
  it 'should raise error for invalid options' #do
  #  lambda {
  #    book = Spreadsheet::Book.new(TESTFILE, {:unsupportedoption => true} )
  #  }.should raise_error()
  #end
  it 'should have have a method for returning the filename' do
    book = Spreadsheet::Book.new(TESTFILE)
    book.filename.should == TESTFILE
  end
  it 'should return an ole_object for the workbook' do
    book = Spreadsheet::Book.new(TESTFILE)
    book.ole_object.class.should == WIN32OLE
  end
end

describe 'Book worksheet iteration' do
  it 'should skip hidden tabs' 
  it 'should skip tabs starting with a comment' 
  it 'should skip tabs that have a color' 
end

describe 'Sheet initialization' do 
  it 'should provide the reference to the Book'
  it 'should return a valid ole_object for the Sheet' 
  it 'should should return the name of the worksheet tab'
  it 'should provide metadata with to_s'
end
describe 'Sheet style detection' do 
  it 'should detect style=:row' 
  it 'should detect style=:col'
  it 'should find header column for style=:row' 
  it 'should find header column for style=:col'
end
describe 'Sheet locate first cell' do 
  it 'should be able to find the first cell for a :row style'
  it 'should be able to find the first cell for a :col style'
  it 'should throw an exception if a first cell cannot be found'
  it 'should be able to handle a worksheet with a single data cell'
end
describe 'Sheet locate last cell' do 
  it 'should be able to find the last cell for a :row style'
  it 'should be able to find the last cell for a :col style'
  it 'should be able to handle a worksheet with a single data cell'
end
describe 'Sheet locate headers' do 
  it 'should be able to find the header cells for a :row style'
  it 'should be able to find the header cells for a :col style'
  it 'should be able to handle a worksheet with a single data cell'
  it 'should throw an exception if the worksheet does not have a header row'
end

describe 'Sheet data extraction' do
  it 'should select the worksheet without throwing an exception'
  it 'should be able to select the home cell without throwing an exception'
  it 'should not detect a colored cell as a datacell'
  it 'should detect a cell without color as a datacell'
  it 'should be able to get a range for a :row style'
  it 'should be able to get a range for a :col style'
  it 'should be able to get the range values from a range for a :row style'
  it 'should be able to get the range values from a range for a :col style'
  it 'should be able to get the worksheet column name from a column index'
  it 'should provide a Record from and row/col index'
  it 'should provide a Cell from a Record index'
end
describe 'Sheet iteration' do
  it 'should be able to iterate over :row records'
  it 'should be able to iterate over :col records'
  it 'should gracefully handle a sheet with no data'
  
end


