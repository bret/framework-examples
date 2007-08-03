require 'spec'
require 'lib/rspec_extensions'
require 'lib/formatter/spreadsheet_formatter'

#TODO: move options parsing here instead of
# pulling from the spreadsheet options
    
module Spreadsheet
  module Fixture
  
    class BaseFixture
      NONE = -4142
      GRAY = 24
      
      def initialize(sheet)
        @sheet = sheet
        @classname = find_class_by_name(sheet.name)
      end
  
      def run
        setup_test
        create_test_fixtures
        teardown_test
      end

      def setup_test
        @rsppec_argv = ['--require', 'lib/formatter/spreadsheet_formatter',
                        '--format', 'Spreadsheet::Formatter::SpreadsheetFormatter']
        @old_behaviour_runner = defined?($behaviour_runner) ? $behaviour_runner : nil
        $behaviour_runner = Spec::Runner::OptionParser.new.create_behaviour_runner(@rsppec_argv, STDERR, STDOUT, false) 
      end
      def run_test
        $behaviour_runner.run(nil, false)
      end
      def teardown_test
        @sheet.select_home_cell
        @sheet.book.save
        $behaviour_runner = @old_behaviour_runner
      end
      
      def create_test_fixtures
      end
      def create_test(name)
      end 
      
      def select_output_cell(c)
        $behaviour_runner.reset
        $behaviour_runner.output_cell = c
      end
      
    end
  end  
end 