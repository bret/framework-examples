module Spreadsheet
  # Load the spreadsheet provided as an argument at the command line.
  # Default is the spreadsheet to use if none is provided.
  # Script is a regexp for the actual script name.
  # Cwd is the current working directory at the time of script execution.
  # Returns the Spreadsheet::Workbook.
  def self.load_from_argv default, script, cwd
    unless ARGV[0] =~ script 
      file = ARGV[0] 
    end
    unless file
      file = default
      cwd = nil
    end
    require 'aims/dsl'
    Spreadsheet::Workbook.new file, cwd
  end
end
