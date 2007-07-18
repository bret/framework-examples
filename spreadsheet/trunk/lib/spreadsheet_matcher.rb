module Spreadsheet
  module SpreadsheetMatcher 

    module CellMatcher
      GREEN = 35
      RED   = 40
      
      def cell_failed(msg)
        @cell.color = RED
        @cell.comment = msg
      end
      
      def cell_passed
        @cell.color = GREEN
      end
    end
    
    class MatchCellValue 
      include CellMatcher
      
      def initialize(cell)
        @cell = cell
        @cell.selectrecord
        cell_passed
        @expected = cell.value
      end
      
      def matches?(actual)
        @actual = actual
        result = (@actual == @expected)
        return result
      end
      
      def failure_message
        message = "expected #{@expected.inspect}, got #{@actual.inspect}"
        cell_failed(message)
        return message, @expected, @actual
      end
      
      def negative_failure_message
        message = "expected #{@actual.inspect} not to equal #{@expected.inspect}"
        cell_failed(message)
        return message , @expected, @actual
      end
    end
    
    def match_cell_value(cell)
      MatchCellValue.new(cell)
    end
    
    class RaiseCellError < Spec::Matchers::RaiseError
      include CellMatcher
      
      def initialize(cell, *args)
        @cell = cell
        cell_passed
        super(*args)
      end
      
      def failure_message
        message = super
        if message
          cell_failed(message)
        end
      end
      
      def negative_failure_message
        cell_failed(super)
      end
    end
    
    def raise_cell_error(cell, *args)
      RaiseCellError.new(cell,*args)
    end
  end
end
