# test ability to parse spreadsheets using a fit-like syntax

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', '..') if $0 == __FILE__
require 'aims/dsl'
require 'watir/testcase'

class FitSpreadsheetTests < Watir::TestCase

  def setup
    @workbook = Spreadsheet::Workbook.new 'test/security/security-tests.spreadsheet.xml'
    @page = @workbook.worksheet('hhernandez')
  end
  def teardown
    @workbook.close
  end

  def test_fixtures
    names_of_fixtures_for_tables = @page.tables.collect {|t| t.name}
    assert_equal ['Login', 'Comment', 'Security Check', 'Comment', 'Security Check'],
      names_of_fixtures_for_tables
  end      

  def test_login_fixture
    login_table = @page.tables[0] 
    login_table.name.should.equal 'Login'
    login_table.rows.should.equal [['hhernandez', '123']]
  end
  
  def test_security_check_fixture
    the_table = @page.tables[2]
    the_table.name.should.equal 'Security Check'
    the_table.should_have(11).rows
    the_table.rows[1][1].should.equal 'Edit Step'
  end
end