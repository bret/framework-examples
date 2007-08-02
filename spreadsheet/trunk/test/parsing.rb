TOPDIR = File.join(File.dirname(__FILE__), '..')
$LOAD_PATH.unshift TOPDIR


require 'spec'
require 'lib/spreadsheet'

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
  it 'should have have a method for returning the filename' do
    book = Spreadsheet::Book.new(TESTFILE)
    book.filename.should == TESTFILE
  end
  it 'should return an ole_object for the workbook' do
    book = Spreadsheet::Book.new(TESTFILE)
    book.ole_object.class.should == WIN32OLE
  end
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

describe 'Whitespace' do
  it_should_behave_like 'SpreadsheetTab'
  before(:each) do
    @sheet = @book['Whitespace']
  end
  it 'should trim leading whitespace' do
    @sheet[2][1].value.should == 'test'
  end
  it 'should trim trailing whitespace' do
    @sheet[2][2].value.should == 'test'
  end
  it 'should not trim middle whitespace' do
    @sheet[2][3].value.should == 'this is a test'
  end
  it 'should trim leading and trailing whitespace' do
    @sheet[2][4].value.should == 'test'
  end
end

describe 'Control Flow - Tabs' do
  it_should_behave_like 'SpreadsheetTab'
  it 'should not include hidden tabs' do
    lambda{ @sheet = @book['ControlFlow.hidden'] }.should raise_error
  end
  it 'should not include colored tabs' do
    lambda{ @sheet = @book['ControlFlow.1'] }.should raise_error
  end
  it 'should not include commented tabs' do
    lambda{ @sheet = @book['ControlFlow.2'] }.should raise_error
  end
end

describe 'Control Flow - Worksheet' do
  it_should_behave_like 'SpreadsheetTab'
  it 'should select worksheet without error' do
    lambda{ 
      @sheet = @book['ColStyle.1'] #select called implicitly
     }.should_not raise_error
  end
  it 'should raise error when calling bogus worksheet' do
    lambda{ 
      @sheet = @book['Bogus'] #select called implicitly
    }.should raise_error
  end
  it 'should select the home cell without error' do
    @sheet = @book['ColStyle.1']
    lambda{ @sheet.select_home_cell }.should_not raise_error
  end
  it 'should properly identify data cells' do
    @sheet = @book['ColStyle.1']
    @sheet.datacell?(1,1).should == false
    @sheet.datacell?(1,2).should == false
    @sheet.datacell?(2,1).should == true
    @sheet.datacell?(2,2).should == true
  end
  it 'should be able to get a range for a :row style' do
    @sheet = @book['ColStyle.1']
    lambda{ @sheet.cellrange(2) }.should_not raise_error
  end
  it 'should be able to get a range of cell values for a :row style' do
    @sheet = @book['ColStyle.1']
    @sheet.cellrangevals(2).should == [1.0,2.0]
  end
  it 'should be able to get a range for a :col style' do
    @sheet = @book['RowStyle.1']
    @sheet.cellrangevals(2).should == [1.0,2.0]
  end
  it 'should be able to get a worksheet column name from a column index' do
    @sheet = @book['ColStyle.1']
    @sheet.colname(1).should == 'A'
    @sheet.colname(2).should == 'B'
  end
  it 'should gracefully handle a sheet with no data' do
    @sheet = @book['Blank']
    lambda{ @sheet.cellrange(2) }.should_not raise_error
  end
end

describe 'Sheet initialization' do 
  it_should_behave_like 'SpreadsheetTab'
  
  it 'should provide the reference to the Book' do
    @book['ColStyle.1'].book.class.should == Spreadsheet::Book
  end
  
  it 'should return a valid ole_object for the Sheet' do
    @book['ColStyle.1'].ole_object.class.should == WIN32OLE
  end
  
  it 'should return the name of the worksheet tab' do
    @book['ColStyle.1'].name.should == 'ColStyle.1'
  end
  
  it 'should provide metadata with to_s' do
    metadata = "firstrow = 2\n" + 
               "firstcol = 1\n" +
               "lastrow  = 7\n" +
               "lastcol  = 2\n" +
               "style    = row\n"
    @book['ColStyle.1'].to_s.should == metadata
  end
end


