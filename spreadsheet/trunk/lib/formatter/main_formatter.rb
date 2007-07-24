module Spreadsheet
  module SpreadsheetMatcher 

    # This should be included in the custom matchers
    # to allow for cell updates in the spredsheet
    # based on the test results
    module CellUpdates
      GREEN = 35
      RED   = 40
      
      def indicate_cell_failed(msg)
        @cell.color = RED
        @cell.comment = msg
      end
      
      def indicate_cell_passed
        @cell.color = GREEN
      end
      
      def select_record
        @cell.selectrecord
      end

    end
  end
end