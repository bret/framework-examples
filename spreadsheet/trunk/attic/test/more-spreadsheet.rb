# test ability to parse spreadsheets using a new syntax

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', '..') if $0 == __FILE__
require 'aims/dsl'
require 'watir/testcase'
require 'spec/mocks/mock'

module FixtureSetup
  def setup_fixture
    @aims_fixture = AIMS::SpreadsheetFixture.new
    @mock_fixture = Spec::Mocks::Mock.new 'mock_fixture'
    @mock_fixture.should_receive(:normalize).any_number_of_times.and_return {|x| @aims_fixture.normalize x}
    @aims_fixture.context = self
  end
  attr_accessor :mock_fixture
end

class DestinationSpreadsheetTests < Watir::TestCase
  include Spreadsheet
  include FixtureSetup
  include AIMS::DSL
  def setup
    @workbook = Spreadsheet::Workbook.new 'test/spreadsheet/old-security-tests.spreadsheet.xml'
    @destination_methods = @workbook.worksheet 'Destination Methods'
    @invoices = @workbook.worksheet 'Invoices'
    setup_fixture
  end
  def teardown
    @workbook.close
  end
  
  def test_each_destination_row
    @destination_methods.should_have(41).rows
  end    
  
  def test_worksheet_dispatch
    mock_fixture.should_receive(:page).exactly(7).times
    mock_fixture.should_receive(:button).exactly(16).times
    mock_fixture.should_receive(:link).exactly(8).times
    mock_fixture.should_receive(:_eval).exactly(10).times
    @destination_methods.dispatch mock_fixture
    mock_fixture.__verify
  end    

  def test_count_scenarios
    @invoices.should_have(20).scenarios
  end
  
  def test_scenario_names
    @invoices.scenarios[0].name.should_equal 'Print'
    @invoices.scenarios[1].name.should_equal 'PDF'    
  end
  
  def test_scenario_dispatch
    mock_fixture.should_receive(:user).once.with(:string)
    mock_fixture.should_receive(:rights_mask).once.with(:string)
    mock_fixture.should_receive(:right_notes).once.with(:string)
    mock_fixture.should_receive(:page).exactly(4).times.with(:anything, :string)
    mock_fixture.should_receive(:button).exactly(15).times.with(:anything, :string)
    mock_fixture.should_receive(:link).exactly(2).times.with(:anything, :string)
    mock_fixture.should_receive(:link_labeled).twice.with(:anything, :string)
    mock_fixture.should_receive(:current_cell=).any_number_of_times
    mock_fixture.should_receive(:activate_cells?).any_number_of_times
    mock_fixture.should_receive(:log_failures_to).any_number_of_times
    @invoices.scenarios[1].dispatch mock_fixture
    mock_fixture.__verify
  end
  
end  

class NewDestinationTests < Watir::TestCase
  include Spreadsheet
  include FixtureSetup
  include AIMS::DSL
  def setup
    @workbook = Workbook.new 'test/spreadsheet/new-rights-suite.spreadsheet.xml'
    @invoices = @workbook.worksheet 'Invoices'
    setup_fixture
  end
  def teardown
    @workbook.close
  end

  def test_scenario_dispatch
    mock_fixture.should_receive(:rights_mask).once.with(:string)
    mock_fixture.should_receive(:right_notes).once.with(:string)
    mock_fixture.should_receive(:page).exactly(4).times.with(:boolean, :string)
    mock_fixture.should_receive(:button).exactly(15).times
    mock_fixture.should_receive(:link).exactly(2).times.with(:anything, :string, :string, :string)
    mock_fixture.should_receive(:link_labeled).twice.with(:anything, :string, :string, :string)
    mock_fixture.should_receive(:current_cell=).any_number_of_times
    mock_fixture.should_receive(:activate_cells?).any_number_of_times
    mock_fixture.should_receive(:log_failures_to).any_number_of_times
    @invoices.scenarios[1].dispatch mock_fixture
    mock_fixture.__verify
  end


end

class ControlPanelTests < Watir::TestCase
  include Spreadsheet
  include FixtureSetup
  include AIMS::DSL
  def setup
    @workbook = Spreadsheet::Workbook.new 'test/spreadsheet/old-security-tests.spreadsheet.xml'
    @control_panel = @workbook.worksheet 'Control Panel'
    setup_fixture
  end
  def teardown
    @workbook.close
  end

  def test_worksheet_dispatch
    mock_fixture.should_receive(:taggart_real_estate_invoice_id).once.with('176')
    mock_fixture.should_receive(:taggart_corporate_invoice_id).once.with('177')
    mock_fixture.should_receive(:worksheet_to_run).once.with(nil)
    mock_fixture.should_receive(:scenario_to_run).once.with(nil)
    mock_fixture.should_receive(:boolean_test_true).once.with(true)
    mock_fixture.should_receive(:boolean_test_false).once.with(false)
    mock_fixture.should_receive(:boolean_test_blank).once.with(nil)
    @control_panel.dispatch mock_fixture
    mock_fixture.__verify
  end   
end