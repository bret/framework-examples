require 'spec'
require 'lib/spreadsheet'

TESTFILE = 'examples/TeamRaiser_model.Spreadsheet'

describe "Bookmark" do
  it 'should fail if booktitle not specified' do
    lambda { bookmark = Spreadsheet::Bookmark.new() }.should raise_error
  end
  it 'should set defaults properly' do
    bookmark = Spreadsheet::Bookmark.new('test')
    bookmark.pagecount.should be_nil
  end
  it 'should not continue from invalid bookmark' do
    lambda {bookmark = Spreadsheet::Bookmark.new('test', true) }.should raise_error
  end
  it 'should support continue with page name only' do
    bookmark = Spreadsheet::Bookmark.new('test', 'PageName')
    bookmark.page.should == 'PageName'
    bookmark.record.should be_nil
  end
  it 'should support continue with page name and record column' do
    bookmark = Spreadsheet::Bookmark.new('test', 'PageName[R]')
    bookmark.page.should == 'PageName'
    bookmark.record.should == 'R'
  end
  it 'should downcase record column in continuation' do
    bookmark = Spreadsheet::Bookmark.new('test', 'PageName[r]')
    bookmark.page.should == 'PageName'
    bookmark.record.should == 'R'
  end
  it 'should support continue with page name and record row' do
    bookmark = Spreadsheet::Bookmark.new('test', 'PageName[2]')
    bookmark.page.should == 'PageName'
    bookmark.record.should == '2'
  end
  it 'should continue from bookmark'
  it 'should set bookmark'
  it 'should clear bookmark'
  it 'should fail if continue from bookmark and no bookmark exists'
  
end