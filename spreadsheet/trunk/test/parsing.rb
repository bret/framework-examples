TOPDIR = File.join(File.dirname(__FILE__), '..')
$LOAD_PATH.unshift TOPDIR

require 'spec'
require 'lib/spreadsheet'

puts `pwd`
TESTFILE = TOPDIR + '/test/parsing.xls'

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

describe 'SpreadsheetTab', :shared => true do
  before(:all) do 
    @book = Spreadsheet::Book.new(TESTFILE)
    @sheet = nil
  end
end
describe 'BasicStyles', :shared => true do
  it_should_behave_like 'SpreadsheetTab'
  it 'should locate the headers' do
    @sheet.headers.should == ['a','b']
  end
end

describe 'Sheet style :col (1)' do 
  it_should_behave_like 'BasicStyles'
  before(:each) do 
    @sheet = @book['ColStyle.1']
  end
  it 'should find the data range' do
    @sheet.firstrow.should == 2
    @sheet.firstcol.should == 1
    @sheet.lastrow.should  == 7
    @sheet.lastcol.should  == 2
  end
end
describe 'Sheet style :col (2)' do 
  it_should_behave_like 'BasicStyles'
  before(:each) do 
    @sheet = @book['ColStyle.2']
  end
  it 'should find the data range' do
    @sheet.firstrow.should == 2
    @sheet.firstcol.should == 2
    @sheet.lastrow.should  == 7
    @sheet.lastcol.should  == 3
  end
end
describe 'Sheet style :col (3)' do 
  it_should_behave_like 'BasicStyles'
  before(:each) do 
    @sheet = @book['ColStyle.3']
  end
  it 'should find the data range' do
    @sheet.firstrow.should == 2
    @sheet.firstcol.should == 1
    @sheet.lastrow.should  == 7
    @sheet.lastcol.should  == 2
  end
end
describe 'Sheet style :col (4)' do 
  it_should_behave_like 'BasicStyles'
  before(:each) do 
    @sheet = @book['ColStyle.4']
  end
  it 'should find the data range' do
    @sheet.firstrow.should == 2
    @sheet.firstcol.should == 2
    @sheet.lastrow.should  == 7
    @sheet.lastcol.should  == 3
  end
end

describe 'Sheet style :row (1)' do 
  it_should_behave_like 'BasicStyles'
  before(:each) do 
    @sheet = @book['RowStyle.1']
  end
  it 'should find the data range' do
    @sheet.firstrow.should == 1
    @sheet.firstcol.should == 2
    @sheet.lastrow.should  == 2
    @sheet.lastcol.should  == 7
  end
end
describe 'Sheet style :row (2)' do 
  it_should_behave_like 'BasicStyles'
  before(:each) do 
    @sheet = @book['RowStyle.2']
  end
  it 'should find the data range' do
    @sheet.firstrow.should == 2
    @sheet.firstcol.should == 2
    @sheet.lastrow.should  == 3
    @sheet.lastcol.should  == 7
  end
end
describe 'Sheet style :row (3)' do 
  it_should_behave_like 'BasicStyles'
  before(:each) do 
    @sheet = @book['RowStyle.3']
  end
  it 'should find the data range' do
    @sheet.firstrow.should == 1
    @sheet.firstcol.should == 2
    @sheet.lastrow.should  == 2
    @sheet.lastcol.should  == 7
  end
end
describe 'Sheet style :row (4)' do 
  it_should_behave_like 'BasicStyles'
  before(:each) do 
    @sheet = @book['RowStyle.4']
  end
  it 'should find the data range' do
    @sheet.firstrow.should == 2
    @sheet.firstcol.should == 2
    @sheet.lastrow.should  == 3
    @sheet.lastcol.should  == 7
  end
end

describe 'Datatypes' do
  it_should_behave_like 'SpreadsheetTab'
  before(:each) do
    @sheet = @book['Datatypes']
  end
  it 'should handle integers' do
    @sheet[2][1].value.class.should == Fixnum
    @sheet[2][1].value.should == 1
  end
  it 'should handle floats' do
    @sheet[2][2].value.class.should == Float
    @sheet[2][2].value.should == 2.0
  end
  it 'should handle hashes' do
    @sheet[2][3].value.class.should == Hash
    @sheet[2][3].value.should == { 'a'=>1, 'b'=>2 }
  end
  it 'should handle arrays' do
    @sheet[2][4].value.class.should == Array
    @sheet[2][4].value.should == ['c', 'd', 'e']
  end
  it 'should handle boolean uppercase' do
    @sheet[2][5].value.class.should == TrueClass
    @sheet[2][5].value.should == true
  end
  it 'should handle boolean lowercase' do
    @sheet[2][6].value.class.should == FalseClass
    @sheet[2][6].value.should == false
  end
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


