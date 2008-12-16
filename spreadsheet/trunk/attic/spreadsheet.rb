require 'win32ole'

class Workbook
    def initialize(file)
        @excel = WIN32OLE::new('excel.Application')
        @workbook = @excel.Workbooks.Open(file)
    end

    def visible=(v)
        @excel['Visible'] = v 
        @visible = v
    end

    attr_reader :sheet # xxx inconsistent with use_page
    attr_reader :visible

    # activate page i of the spreadsheet and return the worksheet ole object        
    def use_page(i)
        @sheet = @workbook.Worksheets(i) 
        @sheet.Select if @visible
        @sheet
    end

    def column_data(column)    
        array = []
        @sheet.range("#{column}:#{column}").each do |cell|
            if cell.value
                array << cell.value
            else
                break
            end
        end
        array
    end

    # return hash with key=>data
    def hash_labelled_column_data(column)
        _array = column_data(column)
        _labels = column_data('a')
        _hash = {}
        _labels.each_with_index do |label, i|
            _hash[label] = _array[i]
        end
        _hash
    end        

    def labelled_column_data(column)
        _array = column_data(column)
        _labels = column_data('a')
        struct = Struct.new(nil, *_labels)
        struct.new(*_array)
    end
    
    def column_names
        # find the right-most column on the worksheet in question
        column_number = @sheet.range("b2").end(-4161).Column
        # setting up an array for columns AA, AB, AC, etc. is troublesome
        raise "Only 25 test cases per workbook, please!" if column_number > 26 
        last_column = @sheet.range("b2").end(-4161).address
        # puts last_column
        last_column =~ /[A-Z]/
        # puts $&
        ("B"..$&)        
    end    
end        
