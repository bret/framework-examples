module Spec
  module Runner
    module SpreadsheetCell
      def cellreference=(c)
        @formatters.each { |f| f.cell=(c) if f.methods.include?('cell=') }
      end
    end
    class BehaviourRunner 
      def reset
        @behaviours = []
      end
      def output_cell=(c)
        @options.reporter.extend SpreadsheetCell
        @options.reporter.cellreference = c
      end
    end
  end
end
