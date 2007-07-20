require 'lib/fixture'

module Spreadsheet
  class ColumnFixture < Spreadsheet::Fixture
  
    def run
      sheet = @sheet
      classname = find_class_by_name(sheet.name)
      sheet.each do |record|
        sheet.select_home_cell
        attributes = []
        record.each do |cell|
          if self.methods.include?(cell.header + '=')
            attributes << [cell.header, cell.value]
          elsif self.methods.include?(cell.header)
            create_rspec_test(sheet, cell, attributes, classname)
          else
            raise ArgumentError, "Unable to identify '#{cell.header}' as a method or attribute in class #{self.class}"
          end
        end
      end
    end
    
    def create_rspec_test(sheet, cell, attributes, classname)
      describe sheet.name do 
        include Spreadsheet::SpreadsheetMatcher
        before(:all) do
          @@actual = nil
        end
        it "#{cell.header}[#{cell.name}] should not throw an exception" do 
          @fixture = classname.new(sheet)
          attributes.each do |attribute, value|
            @fixture.send "#{attribute}=",  value
          end
          if cell.value.to_s.downcase == 'error'
            lambda{@@actual=@fixture.send cell.header}.should raise_cell_error(cell)
          else
            lambda{@@actual=@fixture.send cell.header}.should_not raise_cell_error(cell)
          end  
        end
        it "#{cell.header}[#{cell.name}] should == #{cell.value.to_s}" do 
          @@actual.should match_cell_value(cell) if @@actual
        end
        after(:each) do
          @fixture = nil
        end
      end
    end
    
  end 
end

