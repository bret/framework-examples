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
          elsif  self.methods.include?(cell.header)
            describe sheet.name do 
              include Spreadsheet::SpreadsheetMatcher
              before(:all) do
                @@actual = nil
              end
              before(:each) do 
                @myclass = classname.new(sheet)
                attributes.each do |attribute, value|
                  @myclass.send "#{attribute}=",  value
                end
              end
              it "#{cell.header}[#{cell.name}] should not throw an exception" do 
                if cell.value.to_s.downcase == 'error'
                  lambda{@@actual=@myclass.send cell.header}.should raise_cell_error(cell)
                else
                  lambda{@@actual=@myclass.send cell.header}.should_not raise_cell_error(cell)
                end  
              end
              it "#{cell.header}[#{cell.name}] should == #{cell.value.to_s}" do 
                @@actual.should match_cell_value(cell) if @@actual
              end
            end
          else
            raise ArgumentError, "Unable to identify '#{cell.header}' as a method or attribute in class #{self.class}"
          end
        end
      end
    end
    
  end 
end

