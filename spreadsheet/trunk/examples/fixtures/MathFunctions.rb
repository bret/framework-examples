require 'lib/column_fixture'

class MathFunctions < Spreadsheet::ColumnFixture
  attr_accessor :x, :y
  def add
    x+y
  end
  def subtract
    x-y
  end
  def multiply
    x*y
  end
  def divide
    x/y
  end
end
