require 'roo'

class KeyNotFound < Exception; end
  
class String
  # Opposite of humanize. Converts to lower case and converts spaces to underscores. 
  def computerize
    self.downcase.gsub ' ', '_'
  end
end

# Assumptions
# - OpenOffice
# - Data is stored in columns
# - First row is the "name" of the data set/record
class TestData
  def initialize params
    @spreadsheet = Openoffice.new params[:file]
    @spreadsheet.default_sheet = params[:sheet]
    @raw_keys = @spreadsheet.column(@spreadsheet.first_column)
    this_column = ((@spreadsheet.first_column + 1)..(@spreadsheet.last_column)).detect do |column|
      @spreadsheet.cell(@spreadsheet.first_row, column) == params[:name]
    end
    @raw_values = @spreadsheet.column(this_column)
  end
  def keys
    @keys ||= @raw_keys.map {|k| k.computerize.to_sym}
  end
  def [] key
    index = keys.index key
    raise KeyNotFound, "Key #{key} not found" if index.nil?
    value index
  end
  def each
    keys.each_with_index {|k, i| yield k, value(i)}
  end
  private
  def value index
    @raw_values[index].to_s
  end
end