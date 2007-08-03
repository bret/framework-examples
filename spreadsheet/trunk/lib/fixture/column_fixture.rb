require 'lib/fixture/base_fixture'

module Spreadsheet
  module Fixture
  
    class ColumnFixture < BaseFixture
      
      def create_test_fixtures
        classname = find_class_by_name(@sheet.name)
        @sheet.each do |record|
          test_fixture = classname.new(@sheet)
          record.each do |cell|
            if self.methods.include?(cell.header + '=')
              test_fixture.send "#{cell.header}=",  cell.value
            elsif self.methods.include?(cell.header)
              select_output_cell(cell)
              create_test(test_fixture, cell)
              run_test
            else
              raise ArgumentError, "Unable to identify '#{cell.header}' as a method or attribute in class #{self.class}"
            end
          end
        end
      end
      
      def create_test(fixture, cell)
        describe 'test' do 
          include TestCaseHelperMethods
          
          before(:all) do
            @fixture = fixture
            @cell = cell
            @cell_id = "#{@cell.header}[#{@cell.name}]"
            @@actual_value = nil
            @exception_expected = @cell.value.to_s.downcase == 'error'
          end
          
          it "#{@cell_id} should handle exceptions" do
            check_for_errors
          end
          it "#{@cell_id} should == #{cell.value.to_s}" do 
            check_test_result
          end
          
          after(:all) do
            @fixture = nil
          end
        end
      end
      
      module TestCaseHelperMethods
        def check_for_errors
          if @exception_expected
            lambda{ @fixture.send @cell.header }.should raise_error
          else
            lambda{@@actual_value = @fixture.send @cell.header}.should_not raise_error
          end
        end

        def check_test_result
          @@actual_value.should == @cell.value if ! @exception_expected
        end
      end 
  
    end 
  end  
end

