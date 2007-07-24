module Spreadsheet
  module SpreadsheetMatcher 

    # Match the actual value to the
    # expected value from the spreadsheet cell
    class MatchCellValue 
      include CellUpdates
      
      def initialize(cell)
        @cell = cell
        indicate_cell_passed
        @expected = cell.value
      end
      
      def matches?(actual)
        @actual = actual
        result = (@actual == @expected)
        return result
      end
      
      def failure_message
        message = "expected #{@expected.inspect}, got #{@actual.inspect}"
        indicate_cell_failed(message)
        return message, @expected, @actual
      end
      
      def negative_failure_message
        message = "expected #{@actual.inspect} not to equal #{@expected.inspect}"
        indicate_cell_failed(message)
        return message , @expected, @actual
      end
    end
    
    def match_cell_value(cell)
      MatchCellValue.new(cell)
    end
    
    # Handle expected and unexpecte exceptions
    class RaiseCellError < Spec::Matchers::RaiseError
      include CellUpdates
      
      def initialize(cell, *args)
        @cell = cell
        select_record
        indicate_cell_passed
        super(*args)
      end
      
      def failure_message
        message = super
        if message
          indicate_cell_failed(message)
        end
      end
      
      def negative_failure_message
        indicate_cell_failed(super)
      end
    end
    
    def raise_cell_error(cell, *args)
      RaiseCellError.new(cell,*args)
    end
  end
end
