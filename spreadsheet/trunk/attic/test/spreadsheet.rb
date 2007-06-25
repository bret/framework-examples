$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', '..') if $0 == __FILE__
require 'aims/dsl'
require 'watir/testcase'

class BasicSpreadsheetTests < Watir::TestCase
  include Spreadsheet
  def test_bad_filename
    assert_raises WIN32OLERuntimeError do
      workbook = Spreadsheet::Workbook.new 'no-such-file.xls'
    end
  end
  def test_worksheet_included?
    workbook = Spreadsheet::Workbook.new 'test/vendors/create-vendors.xls'
    assert ! workbook.includes_worksheet?('Matters')
    assert workbook.includes_worksheet?('Vendors')
  end
end

class SpreadsheetTests < Watir::TestCase
  include Spreadsheet
  def setup
    @workbook = Spreadsheet::Workbook.new 'test/vendors/create-vendors.xls'
    @vendor1 = @workbook.worksheet('Vendors')['Vendor1']
  end  
  def teardown
    @workbook.close
  end
  
  def test_access_vendor_data
    @vendor1['Vendor External No'].should.equal 'Vendor1'
    @vendor1['Vendor Tax ID'].should.match /Vendor1 [0-9]+/
  end  
  
  def test_able_to_access_data_by_section
    section = @vendor1.section('Details')
    section['Type'].should.equal 'Recurring'
    section['Street 1'].should.equal nil    
  end
  
  def test_able_to_iterate_through_the_data_nodes
    receiver = Spec::Mocks::Mock.new 'receiver'
    receiver.should_receive(:check).exactly(32).times
    @vendor1.each {receiver.check}
    receiver.__verify
  end
  
  def test_able_to_iterate_through_the_data_for_a_section
    receiver = Spec::Mocks::Mock.new 'receiver'
    receiver.should_receive(:check).exactly(8).times
    section = @vendor1.section('Details')
    section.each {receiver.check}
    receiver.__verify
  end
  
  def test_able_to_read_second_entity
    @vendor2 = @workbook.worksheet('Vendors')['Vendor2']
    @vendor2['Vendor External No'].should.equal 'Vendor2'
  end

  def test_able_to_interpolate
    @vendor1['Name'].should.match /^Vendor1 [0-9]*$/
  end
  
  def test_entities
    worksheet = @workbook.worksheet('Vendors')
    worksheet.should_have(3).entities
  end
  
  def test_whether_a_node_exists
    @vendor1['No Such Data'].should.equal nil
  end    
  
  def test_whether_a_section_exists
    @vendor1.section('No Such Section')['No Such Data'].should.equal nil
  end
  
  def test_worksheet_not_exists
    assert_raises(Spreadsheet::ObjectNotFound) {@workbook.worksheet('No Such Thing')}
  end
  
end

