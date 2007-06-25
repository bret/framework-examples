require 'watir'   # the controller
include Watir
require 'test/unit'
require 'spreadsheet'

class TC_monitor_demo < Test::Unit::TestCase
    
    def setup
        @this_dir = File.expand_path(File.dirname(__FILE__))
        @testSite = "#{@this_dir}\\Jefftextfields.html"
        @outfile = File.new("load.csv", "w")
        @workbook = Workbook.new("#{@this_dir}\\Jeffdemo.xls")
        @workbook.visible = true
    end
    
    def test_monitor_demo    
        #threads = []
        (1..1).each do |i| 
            @workbook.use_page i
            column_array = @workbook.column_names
            column_array.each { |column| execute_workbook_column(column) }
            #threads << Thread.new{automate_excel}
        end
        #threads.each{|x| x.join}
    end
    
    def execute_workbook_column(column)
        test_data = @workbook.labelled_column_data(column)
        
        #poke at the page
        ie = IE.new
        ie.set_fast_speed
        ie.goto(@testSite)
        ie.text_field(:name, "FRO").set(test_data.Date_First)
        ie.text_field(:name, "FRP").set(test_data.Date_Second)
        ie.text_field(:name, "EO").set(test_data.Another_Date)
        ie.text_field(:name, "EP").set(test_data.Looking_Date)
        ie.text_field(:name, "SO").set(test_data.Enter_Date)
        ie.text_field(:name, "SP").set(test_data.How_Date)
        
        ie.radio(:name, "box1").set
        ie.radio(:id, "box5").set
        
        begintime = Time.now
        ie.button(:value,"Submit").click
        submittime = (Time.now - begintime)
        @outfile.puts("Test Case: " + "#{column}, " + "Thread: " + 
                      Thread.current.to_s + ",Load time: " + "#{submittime}")
        
        begin
            assert_match(test_data.Expected_Result,ie.html.to_s)
            #puts("PASS July OK\n")
            @workbook.sheet.Range("#{column}11").Interior['ColorIndex'] = 4 #green
            @workbook.sheet.Range("#{column}11")['Value'] = ['PASS']	    
        rescue => e
            #puts("FAIL Didn't find July")
            @workbook.sheet.Range("#{column}11").Interior['ColorIndex'] = 3 #red
            @workbook.sheet.Range("#{column}11")['Value'] = ['FAIL']
        end	 
        
    end
    
end



