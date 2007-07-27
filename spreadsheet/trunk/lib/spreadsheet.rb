=begin license
  ---------------------------------------------------------------------------
  Copyright (c) 2007, Hugh McGowan, Rafael Torres
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

  3. Neither the names Paul Rogers, nor Bret Pettichord nor the names of any 
  other contributors to this software may be used to endorse or promote 
  products derived from this software without specific prior written 
  permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS
  IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  --------------------------------------------------------------------------
  (based on BSD Open Source License)
=end


=begin rdoc

Look at FIT
check for method=
arity on method returns arg count
webgen
cell validation in the excel spreadsheet

  Spreadsheet Components
  ======================
  
  Headers: A row or column of descriptions. This cell range abuts
  the data cells and usually corresponds to the function or method being 
  called, with the data being parameters or attributes. Headers can also be 
  preceded with an asterisk(*) if you wish to indicate which headers
  are required information. These asterisks are automatically removed
  when the spreadsheet is read. 
  [Style = Bold, Cell Shaded]
  
  Data: The data should comprise the bulk of information on the spreadsheet
  and represents the parameters used for the function or testcase (which we
  get from the header cells).
  [Style = None]
  
  Comments: Any text in shaded cells along the top or left of the spreadsheet.
  You can have as many rows or columns of comments as you like, presuming 
  all of the other rules are followed.
  [Style = Bold, Cell Shaded]
  
  Valid Data Configurations
  =========================
  
  This library has a few requirements about the format of the
  worksheet data so it can be properly parsed. For the sake of example, 
  cells that are shaded are bordered by '.', 'H' represents Header cells and 
  'd' represents data. Any shaded cell that is blank could be used for comments.

  This is the simplest way to format the data with a single
  row or column of header cells (shaded) with data 
  
  + . +---+---+    + . + . + . +   
  . H | d | d |    . H . H . H .   
  + . +---+---+    +---+---+---+   
  . H | d | d |    | d | d | d |   
  + . +---+---+    +---+---+---+   
  | H | d | d |    | d | d | d |   
  + . +---+---+    +---+---+---+   

  You can also add additional shaded columns to the top and
  left to make room for any comments that may be helpful
  
  + . + . + . + . +    + . + . + . + . +   
  .   .   .   .   .    .   . H . H . H .   
  + . + . +---+---+    + . +---+---+---+   
  .   . H | d | d |    .   | d | d | d |   
  + . + . +---+---+    + . +---+---+---+   
  .   | H | d | d |    .   | d | d | d |   
  + . + . +---+---+    + . +---+---+---+   

  The library will inspect the worksheet and determine the first
  data cell (upper left) by looking for the first non-shaded 
  cell. The last datacell (lower right) will be used with that first 
  data cell to form a rectangle representing the boundaries of the 
  test data. Then, the cells to the left and top of the first data
  cell will be looked at to see if the text in the cell is bolded. 
  If so, it's assumed to be the header row. 

  Skipping Data
  =============
  
  The following items will be skipped and not parsed. This gives an 
  easy way to disable data
  
  - Spreadsheet tabs that are colored (right click the tab and change the
  Tab Color) 
  - Spreadsheet tabs that START with a comment (using #). 
  - Spreadsheet rows that are italicized
  
  Note that you CAN have comments in a tab and the comment portion 
  will be stripped before it's used. This is actually useful because 
  it works around Excel's requirement that every tab name is unique.
  So for example you could have MyTab#a, MyTab#b as separate tabs in
  the spreadsheet and MyTab will be returned by Book.each. (though 
  you do need to specify the full tabname with the comment when using
  the :continue option) 

  Bookmarks
  ==========
  
  There are a few features around continuing from a bookmark or a given 
  point in the spreadsheet. This is accomplished with the :continue option. 
  
  While the spreadsheet is parsed, a bookmark is dropped before each row/col
  of data is read. This bookmark is stored in the '.bookmarks' file and is 
  unique for each spreadsheet run in that directory. If for some reason the
  script execution is interrupted or the script aborts unexpectedly, you can
  simply pick up where you left off by using :continue => true. 
  
  Further you have much more control and can specify a specific tab to start
  from and even a row/col (depending on the spreadsheet format). This follows
  the format :continue => TabName[row/col]. So you could do any of the 
  following: MyTab, MyTab[F], MyOtherTab[10] and the lib will not start returning 
  any spreadsheet data till that location is found. 
  
  You can also specify a maximum number of pages to process when you're 
  continuing using the :pagecount => [number]. In conjunction with :continue, 
  this allows you to run exactly one tab if you like. Without :pagecount, the
  spreadsheet will be read from the continuation point till the end of the 
  workbook. 
  
  Example
  =======

  OPTIONS = 
  :visible          Make the Excel Spreadsheet visible when processing
  :continue         Continue from a bookmark
  :pagecount        Continue for n pages after a bookmark
  
  book = Spreadsheet::Book.new(spreadsheet, { :visible => true })
  book.each do |sheet|
    puts '---' + sheet.name + '---'
    puts sheet.to_s
    sheet.each do |record|
      record.each do |cell|
         puts "\t#{cell.header}=#{cell.value}"
      end
    end
  end  

  TODO: 
  Handle true/false, numbers so we're not passing in the string
  Work out how to handle verification - maybe using tab have a static method?
  
 
=end

module Spreadsheet
  require 'logger'
  require 'singleton'

  # Singleton Class to store Excel Constant Variables
  class ExcelConst; include Singleton; end
 
  # As the spreadsheet is used, bookmarks are dropped with each 
  # read of a cell into a .bookmarks file. Then the user can 
  # continue from the last read cell. This is useful in the 
  # event the action executed by the spreadsheet runner fails 
  # or is interrupted. 
  #
  # The continue feature can also be used to start the
  # script from a specific tab and/or row/col in the spreadsheet.
  # Additionally you can specify the number of pages to process
  # so a user can start from SheetA and process 2 Sheets in the 
  # spreadsheet. 
  #
  # Bookmarks are formatted as follows:
  #
  # PageName[Col|Row]
  #
  # where the Col/Row is an optional parameter. This gives the 
  # following bookmarks as possible continuation points:
  #
  # SheetA              start from this sheet
  # SheetA[10]          this sheet is style :row, so start from row 10
  # SheetA[F]           this sheet is style :col, so start from column F
  # true                use the bookmark stored in .bookmarks
  #
  # The pagecount allows the user to start at the desired bookmark
  # but only run through 1 or more sheets in the workbook
  class Bookmark
    class ObjectNotFound < RuntimeError; end
    
    @foundpage   = false
    @foundrecord = false
    attr_accessor :pagecount, :page, :record
    
    def initialize(booktitle, continue=nil, pagecount=nil)
    
      # The booktitle is name we're associating this bookmark to
      # which for our purpose is essentially the xls filename. This
      # allows us to store separate bookmarks for each spreadsheet
      @booktitle = booktitle
      
      # Continue from last saved bookmark or
      # use the bookmark specified by the user
      if continue == true
        bookmarkname = self.get 
        raise Bookmark::ObjectNotFound, "No bookmark found for '#{@booktitle}'" if bookmarkname.nil?
      else
        bookmarkname = continue
      end
      
      # Track page counts
      @currentpage = 1
      if pagecount
        @pagecount = pagecount.to_i
        raise ArgumentError, "Invalid pagecount '#{@pagecount}'" if @pagecount && @pagecount <= 0
      end  
      
      # Parse the bookmark into it's parts so we can 
      # check for it as we read in the Sheet Records and Cells
      @page, @record = parse_bookmark(bookmarkname)
      raise ArgumentError, "Invalid record '#{@record}' - argument must be a row or column name" if @record && @record.length > 1
    end
    # Check to see if the current record or page matches the bookmark.
    # For example, found?(:sheet, [pagename]) or found?(:record, [row/col])
    # where pagename is the name of the worksheet and row/col could be the
    # row or column depending on the style of the page (eg: 'A' or 6)
    def found?(how, what)
      case how
      when :sheet
        if @foundpage
          # increment our page counter and exit if 
          # we hit a specified page count
          @currentpage += 1
          exit if @pagecount && @currentpage > @pagecount
          
          # Trap the case when a record is specified 
          # for a page and it does not exist
          if !@foundrecord && what != @page
            raise Bookmark::ObjectNotFound, "Record #{@record} does not exist on page #{@page}"
          end
          
          true
        else
          if what == @page
            @foundpage = true
            # Set the foundrecord true so that it always 
            # passes the comparison if the record is not set
            @foundrecord = true if !@record
            true
          else
            false
          end
        end
      when :record
        raise Bookmark::ObjectNotFound, 'Should never get here: page should have been found first' if !@foundpage
        if @foundrecord
          true
        else
          if what == @record
            @foundrecord = true
            true
          else
            # TODO: RAISE if wrong type. (row is specified but it's a col)
            false
          end
        end
      else
        raise ArgumentError, "Don't know how to check bookmark for '#{how}'"
      end
    end
    def clear
      write { |lines| lines.delete(@booktitle) }
    end
    def set(page, record)
      write { |lines| lines[@booktitle] = "#{page}[#{record}]" }
    end
    def get
      read[@booktitle]
    end
  private 
    def parse_bookmark(name)
      name =~ /\b(\w+)\b(\[(\S+)\])?/
      pagename = $1
      recordid = $3.upcase if $3
      return pagename, recordid
    end
    def read
      page = nil
      lines = Hash.new
      filename = File.expand_path(".bookmark")
      if File.exists?(filename)
        File.open('.bookmark', 'r') do |f|
          lines = Marshal.load(f)
        end
      end
      lines
    end
    def write(&block)
      lines = Hash.new
      filename = File.expand_path('.bookmark')
      if File.exists?(filename)
        File.open('.bookmark', 'r') do |f|
          lines = Marshal.load(f)
        end
      end
      block.call(lines)
      File.open('.bookmark', 'w') do |f|
        Marshal.dump lines, f
      end
    end
  end
  
  
  # This object is a container for the Excel workbook and 
  # any options passed into the library. 
  # 
  # :visible          Make the Excel Spreadsheet visible when processing
  # :continue         Continue from a bookmark
  # :pagecount        Continue for n pages after a bookmark
  #
  # The book object can be parsed to find Records which in turn
  # can be parsed to locate Cells. 
  class Book
    require 'win32ole'
    attr_accessor :visible, :continue, :pagecount
    attr_reader :filename, :bookmark, :options
    def initialize(xlsfile, options={})
      raise ArgumentError, 'XLS file required for Book.new()' if !xlsfile
      # Handle options
      self.visible = false
      self.continue = false
      self.pagecount = nil
      
      # Presume that the options are all Book attributes
      # and set the value or the attribute accordingly
      @options = options
      @options.each_key do |k| 
        next if ! self.methods.include?(k.to_s + '=') # skip if we don't know how to handle
        begin
          case @options[k] 
          when true, false
            eval("self.#{k.to_s} = #{options[k]}")   
          else
            eval("self.#{k.to_s} = '#{options[k]}'") 
          end
        rescue ArgumentError
          raise ArgumentError, "Unknown option #{k}"
        end
      end
      
      @filename = xlsfile
      raise IOError, "Unable to find file: '#{@filename}'" if ! File.file?(@filename)
      @bookmark = Bookmark.new(@filename, continue, pagecount) if continue

      # Open the workbook and get the ole reference to the workbook object
      @excel = WIN32OLE::new('excel.Application') 
      @o = @excel.Workbooks.Open(File.expand_path(@filename))
      @excel['Visible'] = visible
      
      # Get the standard set of Excel constants
      WIN32OLE.const_load(@excel, ExcelConst) if ExcelConst.constants == []
      
      # Make sure we close the workbook at exit 
      # or we'll have a dangling Excel process
      at_exit {
        if !@options[:visible]
          @o.close if @o
          if @excel 
            while @excel.ActiveWorkbook
              @excel.ActiveWorkbook.Close(0)
            end
            @excel.Quit();
          end
        end
      } 
    end  
    def [](name)
      Sheet.new(self, @o.Worksheets(name))
    end
    def each
      @o.Worksheets.each do |worksheet| 
        next if @o.Worksheets(worksheet.name).Visible == 0              # Skip hidden worksheets
        next if worksheet.name =~ /^#/                                     # Skip commented sheets
        next if worksheet.Tab.ColorIndex != ExcelConst::XlColorIndexNone   # Skip worksheets with colored tabs 
        next if continue && !@bookmark.found?(:sheet, worksheet.name)       # Skip if we have not found a bookmark
        yield Sheet.new(self, worksheet)
      end
    end
    def ole_object 
      @o
    end
    def save
      @o.Save if @excel
    end
  end
    
  # Sheets store the information about records on the sheet. 
  # In order to allow the user to add comments and have flexibility
  # with how the data is laid out we have the following requirements:
  #
  # * The data will start at the first non-colored cell closest to Cell 'A1'
  # * Colored cells will be ignored until we hit the first data cell. 
  # * The header row (this is usually the attribute you're going to set) needs
  #   to be bolded. We will use which side of the data (top or left) to determine
  #   if the data is laid out in rows or in columns. 
  # 
  # Iterating over the Sheet will return Records which represent the row/column
  #
  
  class Sheet
    attr_reader :style, :name, :headers, :book,
                :firstrow, :firstcol, :lastrow, :lastcol
    def initialize(book, worksheet)
      # TODO: Add check for duplicates if option set
      @book     = book
      @o        = worksheet
      @name     = worksheet.name
      self.select
      # Order here is important because in these functions we
      # will use the class variables from the prior call
      (@lastrow, @lastcol)   = locate_last_data_cell
      (@firstrow, @firstcol) = locate_first_data_cell
      (@headers, @style)     = locate_headers
    end
    def to_s
      "firstrow = #{@firstrow}\n" +
      "firstcol = #{@firstcol}\n" +
      "lastrow  = #{@lastrow}\n"  +
      "lastcol  = #{@lastcol}\n"  +
      "style    = #{@style}\n"
    end
    def select
      @o.Select
    end
    def select_home_cell
      @o.Cells(1,1).Select
    end
    # A cell is a data cell if the color attribute for the cell is not set
    def datacell?(row,col)
      @o.Cells(row,col).Interior.ColorIndex == ExcelConst::XlColorIndexNone
    end
    # Get an array of the values of cells in the range describing the row or column      
    def cellrangevals(index, style=@style)
      range = cellrange(index, style)
      case style
      when :row
        range['Value'][0] 
      when :col
        range['Value'].map{ |v| v[0] }
      end
    end
    # Get the ole range object for a row or column      
    def cellrange(index, style=@style)
      case style
      when :row
        @o.Range("#{colname(@firstcol)}#{index}:#{colname(@lastcol)}#{index}")
      when :col
        @o.Range("#{colname(index)}#{@firstrow}:#{colname(index)}#{@lastrow}")
      end
    end
    # Translate a numerical column index to the alpha worksheet column the user sees
    def colname(col)
      @o.Columns(col).address.slice!(/(\w+)/)
    end
    def each
      case @style
      when :row
        firstrecord = @firstrow
        lastrecord  = @lastrow 
      when :col
        firstrecord = @firstcol
        lastrecord  = @lastcol
      end
      (firstrecord..lastrecord).each do |record_index|
        yield Record.new(self, record_index)
      end
    end
    def ole_object
      @o
    end
    def cell (record_index, cell_index)
      Cell.new(self, record_index, cell_index)
    end
    def [](index)
      Record.new(self, index)
    end
  private
    def locate_first_data_cell
     (1..@lastrow).each do |row|
       (1..@lastcol).each do |col|
          if datacell?(row,col)
            return row, col
          end
        end
      end
      raise ObjectError, "Unable to locate first data cell on worksheet '#{@sheet.name}'"
    end
    def locate_last_data_cell
      row = @o.Cells.Find('What'            => '*',
                          'SearchDirection' => ExcelConst::XlPrevious,
                          'SearchOrder'     => ExcelConst::XlByRows).Row
      col = @o.Cells.Find('What'            => '*',
                          'SearchDirection' => ExcelConst::XlPrevious,
                          'SearchOrder'     => ExcelConst::XlByColumns).Column
      return row, col
    end
    def locate_headers
      headerrow = @firstrow - 1
      if headerrow == 0 
        testcell = @o.Cells(1,@firstcol)
      else
        testcell = @o.Cells(headerrow,@firstcol)
      end
      if headerrow > 0 && testcell.Font.Bold && testcell.Value.to_s.strip != ''
        style = :row
        headers  = cellrangevals(@firstrow-1, :row)
      else
        style = :col
        headers  = cellrangevals(@firstcol-1, :col)
      end
      return headers, style
    end
  end

  # Records store the information of a particular row/col of 
  # a worksheet and allow iterating through the Record's Cells
  class Record
    attr_reader :recordindex
    def initialize(sheet, index)
      @sheet       = sheet
      @book        = sheet.book
      @recordindex = index
      @range = @sheet.cellrange(@recordindex)
    end
    def each
      @sheet.headers.each_index do |cell_index| # should be a value for each header
        cell = @sheet.cell(@recordindex,cell_index + 1)
        return if @book.continue && ! @book.bookmark.found?(:record, cell.recordid)
        if cell.value 
          # Drop a bookmark so we can continue from it later
          @book.bookmark.set(@sheet.name,cell.recordid) if @book.continue
          yield cell 
        end
      end
    end
    def select
      @range.Select
    end
    def [](index)
      Cell.new(@sheet, @recordindex, index)
    end
  end
  
  # Cells store information on a specific worksheet cell. 
  # The name is the Excel name for the cell (ie: A1, B2, etc), 
  # the value is the value of the cell and the header is the 
  # header for that row/column (usually the attribute/function parameter
  # we're trying to set)
  class Cell
    ARRAY  = /\A\[[^\]]+\]\Z/
    HASH   = /\A\{[^\}]+\}\Z/
    BOOL   = /\A(true|false)\Z/i
    NUMBER = /\A-?\d+\.??\d*?\Z/
    attr_reader :name, :value, :recordid, :recordindex,
                :sheet, :book

    def initialize(sheet, record_index, cell_index)
      @sheet       = sheet
      @book        = sheet.book
      @o           = sheet.ole_object
      @cellindex   = cell_index
      @recordindex = record_index
      case @sheet.style
      # We use .Text instead of .Value for the cell contents 
      # because otherwise numbers are not handled well
      when :row
        @row = @recordindex 
        @col = @cellindex + @sheet.firstcol - 1 # taking into account the start of the used data range
        @cell = @o.Cells(@row,@col)
        @value = @cell.Text
      when :col
        @row = @cellindex + @sheet.firstrow - 1 # taking into account the start of the used data range
        @col = @recordindex 
        @cell = @o.Cells(@row,@col)
        @value = @cell.Text
      end
      # Ignore blank values. There's not much use for cells 
      # that are not set so skip them and normalize the return 
      # to nil so we know that's the case
      @value = @value.to_s.strip
      if @value == ''
        @value = nil 
      elsif @value =~ ARRAY || @value =~ HASH || @value =~ BOOL 
        @value = eval(@value)
      elsif @value =~ NUMBER
        #handle Excel conversion of integer to float
        @value = eval(@value)
      end
      #TODO: find a way to add other handlers
      #if @value =~ /(\d{4})\/(\d{2})\/(\d{2}) \d{2}:\d{2}:\d{2}$/  # handle excel automatic handling of dates
       #  @value = "#{$2}/#{$3}/#{$1}"
      #end
      
      # Put together the cell's name
      column_letter = @sheet.colname(@col)
      @name = column_letter + @row.to_s
      
      # The recordid is the row/col for the record
      case @sheet.style
      when :row
        @recordid = @row.to_s
      when :col
        @recordid = column_letter
      end
    end
    def header
      @sheet.headers[@cellindex-1]
    end
    def color=(c)
      @cell.Interior.ColorIndex = c
    end
    def color
      @cell.Interior.ColorIndex
    end
    def comment=(c)
      if c && !@cell.Comment
        c.scan(/(\bexpected\b.+,) (\bgot\b.+)/) do |exp, act|
          c = "#{exp}\n#{act}"
        end
        @cell.AddComment(c) 
        @cell.Comment.Shape.TextFrame.AutoSize = true
      end
    end
    def selectrecord
      range = @sheet.cellrange(@recordindex)
      range.Select
    end
    def value=(v)
      @cell.Value = v
    end
  end

  
end # module
