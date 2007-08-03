module Spreadsheet
  module Formatter
    class SpreadsheetFormatter <  Spec::Runner::Formatter::BaseFormatter
      GREEN = 35
      RED   = 40
      
      def cell=(c)
        @cell = c
      end
      
      def example_failed(example, counter, failure)
        @cell.color = RED
        @cell.comment = failure.exception.message
      end
      
      def example_passed(example)
        @cell.color = GREEN if @cell.color != RED
      end
      
      def start_dump
        @cell.selectrecord
      end
      
    end
  end
end