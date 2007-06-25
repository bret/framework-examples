# load data from a spreadsheet (*.xls) for AIMS

module AIMS
  module DSL
    # Take a string with embedded #{} and evaluate it just
    # like the native Ruby string interpolator does with double-quotes.
    # Example:
    #   interpolate '#{2+2}' => "4"
    def interpolate string
      return nil if string.nil?
      string.gsub(/\#\{(.*)\}/) {eval $1}
    end
  end
  class SpreadsheetFixture
    def normalize data
      return nil if data == ''
      case data.upcase
      when 'TRUE'
        return true
      when 'FALSE'
        return false
      end
      data = context.interpolate data
    end
    def context
      @aims
    end
    def context= it
      @aims = it
    end
  end
end

module Spreadsheet
  class ObjectNotFound < RuntimeError
  end
  class Workbook
    TopDir = File.join(File.dirname(__FILE__), '..')
    def initialize file, relative_to=nil
      @excel = WIN32OLE.new 'excel.application'
      relative_to ||= TopDir
      full_path = File.expand_path(File.join(relative_to, file))
      @ole_workbook = @excel.workbooks.open(full_path)
      puts "Loaded spreadsheet: #{full_path}"
    end
    def worksheet name
      begin
        ole_worksheet = @ole_workbook.worksheets(name)
      rescue WIN32OLERuntimeError
        raise Spreadsheet::ObjectNotFound, "Worksheet not found #{name}"
      end
      Worksheet.new(ole_worksheet)
    end
    def worksheets
      worksheets = @ole_workbook.worksheets.extend Enumerable
      worksheets.collect {|w| Worksheet.new w}
    end
    def includes_worksheet? name
      worksheets.detect {|w| w.name == name}
    end
    def close
      @ole_workbook.close
      @excel.quit
      @excel = nil
      GC.start
    end    
  end     
  
  class Worksheet
    def initialize ole_worksheet        
      @ole_worksheet = ole_worksheet
    end
    def name
      @ole_worksheet.name
    end
    def activate
      excel.visible = true unless excel.visible
      @ole_worksheet.activate
    end
    def each_entity
      monikers_by_column do | moniker, column |
        yield self[moniker]
      end
    end
    def entities
      entities = []
      each_entity do | entity |
        entities << entity
      end
      entities
    end
    def monikers_by_column
      @ole_worksheet.cells(1,1).value.should.equal 'Moniker'
      column = 2
      while moniker = @ole_worksheet.cells(1, column).value
        yield moniker, column
        column += 1
      end
    end
    def [] index 
      EntityData.new @ole_worksheet, index 
    end
    def tables
      Tables.new @ole_worksheet
    end
    # Return the rows that have actions (not comments).
    # Comments are any rows with text in the first column.
    # Actions must have text in the second column (but not the first).
    def rows
      rows = @ole_worksheet.usedRange.rows.extend Enumerable
      rows.select do |row|
        entire_row = row.entireRow
        entire_row.columns(1).text == '' and # comment
        entire_row.columns(2).text != '' # no action
      end
    end
    # Execute the rows of the worksheet using the fixture.
    def dispatch fixture
      rows.each do |row|
        columns = row.columns.extend Enumerable
        action = columns.collect {|column| column.text}
        action.shift if action[0] == ''
        method = action.shift.downcase.gsub(' ','_').to_sym 
        method = :_eval if method == :eval
        action.collect! {|data| fixture.normalize(data)}
        fixture.__send__ method, *action
      end
    end
    def first_scenario
      return @first_scenario if @first_scenario
      first_row = @ole_worksheet.usedRange.rows(1).columns.extend Enumerable
      @first_scenario =
        first_row.each_with_index do | cell, index |
          if cell.text == 'Scenarios'
            break index 
          end
        end
    end

    # Return the columns that have scenarios defined.
    def scenarios
      columns = @ole_worksheet.usedRange.columns.extend Enumerable
      scenario_columns = []
      columns.each_with_index do | column, index |
        next if index < first_scenario
        scenario = Scenario.new(self, index, column)
        next unless scenario.name
        scenario_columns << scenario
      end
      scenario_columns
    end  
    # Return the specified column (0-based index)
    def column index
      @ole_worksheet.usedrange.columns(index + 1)    
    end
    private
    def excel
      @ole_worksheet.application
    end
  end      

  class ScenarioNameFixture < AIMS::SpreadsheetFixture
    def scenario_name note=nil
      if note
        @scenario_name = note
      else
        @scenario_name
      end
    end
    def right_notes note
      @scenario_name = note
    end
    def method_missing *args
    end
  end  

  class Scenario
    include AIMS::DSL # for interpolate
    attr_accessor :column, :worksheet, :column_index
    BLUE   = 0xFF0000
    GREEN  = 0x00FF00
    RED    = 0x0000FF
    YELLOW = 0x00FFFF
    LIGHT_BLUE = 0xFFCCCC
    LIGHT_GREEN = 0xCCFFCC
    LIGHT_RED = 0xCC99FF
    def initialize worksheet, index, column=nil
      @worksheet = worksheet
      @column_index = index # 0-based
      column = worksheet.column(index) if column.nil?
      @column = column
    end
    def name
      name_fixture = ScenarioNameFixture.new
      name_fixture.context = self
      dispatch name_fixture
      name_fixture.scenario_name
    end
    def dispatch fixture
      rows.each do |row|
        args = []
        entire_row = row.entireRow.extend Enumerable
        action = entire_row.columns(2).text
        3.upto(@worksheet.first_scenario) do | column |
          row_argument = fixture.normalize entire_row.columns(column).text
          args << row_argument if row_argument != nil
        end
        cell = entire_row.columns(@column_index + 1)
        scenario_arg = fixture.normalize cell.text
        args.unshift scenario_arg
        if fixture.activate_cells?
          cell.select
          cell.interior.color = YELLOW
          fixture.log_failures_to cell
        end 
        
        method = action.downcase.gsub(' ','_').to_sym
        result = fixture.__send__ method, *args
        fixture.log_failures_to nil
        if fixture.activate_cells?
          color = case result
            when true:  LIGHT_GREEN
            when false: LIGHT_RED
            else        LIGHT_BLUE
          end
          cell.interior.color = color
        end
      end
    end
    def rows
      worksheet.rows
    end
    def select
      @column.select
    end
  end
  
  module DataValue
    def [] index
      node = data_node(index)
      if node
        node.value
      else
        nil
      end
    end
  end

  class EntityData
    include DataValue
    include AIMS::DSL
    attr_accessor :moniker
    def initialize worksheet, moniker
      @ole_worksheet = worksheet
      @moniker = moniker
      find_column
      load_data
    end

    private
    def find_column
      Worksheet.new(@ole_worksheet).monikers_by_column do |moniker, column|
        if @moniker == moniker
          @column = column
          return
        end
      end
      raise "Moniker #{@moniker} not found."
    end
      
    def load_data
      @data = []
      row = 2 
      while name = @ole_worksheet.cells(row, 1).value
        if name =~ /^Section: (.*)$/
          section_name = $1
        elsif name =~ /^Under Label: (.*)$/
          under_label = $1
        else
          node = Spreadsheet::DataNode.new
          node.name = name
          value = @ole_worksheet.cells(row, @column).text
          node.value = interpolate value
          node.section = section_name
          node.under_label = under_label
          @data << node
        end
        row += 1
      end
    end
    
    public
    def data_node index
      @data.detect {|x| x.name == index}
    end
    def each
      @data.each {|x| yield x}
    end
    
    def section name
      Section.new name, self
    end
  end
  
  class Tables
    include Enumerable
    @current_row
    def initialize ole_worksheet
      @ole_worksheet = ole_worksheet
      @tables = []
      @current_row = 1
      while row_name = ole_worksheet.cells(@current_row, 1).value do
        @tables << Spreadsheet::Table.new(row_name, @current_row, @ole_worksheet)
        skip_rows_with_text
      end
    end
    
    def skip_rows_with_text
      while @ole_worksheet.cells(@current_row, 1).value
        @current_row +=1
      end
      @current_row +=1
    end

    def each &block
      @tables.each &block
    end
    def [] index
      @tables[index]
    end
  end

  class Table
    attr_accessor :name, :rows
    def initialize name, top_row, ole_worksheet, left_column = 1
      row = top_row + 2
      @name = name
      @left_column = left_column
      @rows = []
      while ole_worksheet.cells(row, @left_column).value do
        this_row = []
        column = @left_column
        while value = ole_worksheet.cells(row, column).value
          this_row << value
          column += 1
        end
        @rows << this_row
        row += 1
      end
    end
  end
  
  class Section
    include DataValue
    def initialize section_name, entity
      @name = section_name
      @entity = entity
    end
    def included? node
      node.section == @name
    end

    def data_node index
      node = @entity.data_node index
      if node && included?(node) 
        then node
      else
        nil
      end
    end
    def each
      @entity.each {|x| yield x if included?(x)}
    end
  end
  
  DataNode = Struct.new :name, :value, :section, :under_label
  
end

