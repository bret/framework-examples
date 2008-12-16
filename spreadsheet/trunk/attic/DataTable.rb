=begin license
Copyright (c) 2005, Qantom Software
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution. 
Neither the name of Qantom Software nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(based on BSD Open Source License)
=end



module WET

=begin rdoc
    class to represent datatable to allow parametrization 
    of tests.
=end
    class DataTable
      
            #private Excel.Application @excl
            #private WorkBook @worbook
            #private WorkSheet @worksheet
            #private String[] @fields
            #private String[] @categories
            #private String @cur_category
    
=begin rdoc
    Constructor that takes a file argument. The file is the full
    path to the Excel spreadsheet that will serve as the datatable
=end
            def initialize(file)
                @exl = WIN32OLE.new('Excel.Application')
                debug file
                @workbook = @exl.Workbooks.open(full_path(file, false))
                set_sheet(1) 
                @exl.Visible = true
            end
            
=begin rdoc
    Set the active sheet to one of the Excel file's worksheet. 
=end
            def set_sheet(sheet_index)
                @worksheet = @workbook.WorkSheets(sheet_index)
                @worksheet.activate            
                read_defined_values()
            end
            
=begin rdoc
    Get the text in the specified cell.
=end
            def cell(row, col)
                return @worksheet.Cells(row, col).text()
            end
            
=begin rdoc
    Get the number of columns in the table. The number of 
    columns also represents the number of fields 
=end
            def col_count()
                return @fields.length
            end
            
=begin rdoc
    Get the number of rows in the table. The number of rows 
    also represents the different categories of data
=end    
            def row_count()
                return @categories.length
            end        
       
=begin rdoc
    Set the current iteration's category. 
=end
            def set_category(cat)
                @cur_category = cat
            end
            
=begin rdoc
    Get the value of the item for the specified field
    If the optional cat parameter is specified, then the value for
    the filed for that category of data is retreived. Otherwise the 
    data for the current iteration's cataegory is returned
=end
            def item(field, cat=@cur_category)            
                row_index = @categories.index(cat)
                col_index = @fields.index(field)
                return_value = nil
                if row_index == nil || col_index == nil
                    #
                else
                    #Excel cells are not zero based
                    row_index = row_index + 1
                    col_index = col_index + 1
                    #Also remember that we have not considered the first row
                    #as a data item - The first row will have the names
                    #of the fields themselves
                    row_index = row_index + 1
                    return_value = @worksheet.Cells(row_index, col_index).text.to_s() 
                end
            end
        
            def close()
                @workbook.close(0)
                @exl.quit
            end
        
            private 
            def read_defined_values()
                @fields = []
                @categories = []
                #First read all the columns - this indicates the fields
                cur_col = 1
                cur_row = 1
                while true do
                    val = @worksheet.Cells(cur_row, cur_col).value.to_s()
                            
                    if val.strip() == "" 
                        break 
                    else
                        @fields << val
                    end
                    cur_col = cur_col + 1
                end         
                
                #Now ready the rows in the first col - indicates type of data
                cur_col = 1
                cur_row = 2            
                while true do
                    val = @worksheet.Cells(cur_row, cur_col).value.to_s()
                    if val.strip() == "" 
                        break 
                    else
                        @categories << val
                    end
                    cur_row = cur_row + 1
                end     
                
            end
    end
end
