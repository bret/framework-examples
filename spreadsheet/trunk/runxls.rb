$LOAD_PATH.unshift File.dirname(__FILE__) if $0 == __FILE__
require 'optparse'
require 'lib/spreadsheet'

# Handle login/host information
continue = false
opt = Hash.new
opt[:pagecount] = false
opt[:continue] = false
parser = OptionParser.new do |cli|
  cli.banner += " [file(s) ...]"
  cli.on('-q', '--quiet', 'Log only warnings and errors')  { opt[:logging] = 'quiet' }
  cli.on('--continue [bookmark]', 'Continue spreadsheet from last checkpoint or designated bookmark') { |opt[:continue]|; opt[:continue] = true if !opt[:continue]}
  cli.on('--pagecount [numpages]', 'Number of pages to process')  { |opt[:pagecount]|}
  cli.on('--help', 'Show the detailed help and quit') { opt[:help] = true  }
end

# Parse the commandline args
parser.parse!(ARGV)

if opt[:help]
  puts parser.help 
  puts morehelp
  exit
end

# Report all errors together
errmsg = String.new

# Collect the spreadsheets and make sure the files exist
ARGV.options = nil
spreadsheets = ARGV
if ! errmsg.empty? || spreadsheets.empty?
  puts parser.help
  puts errmsg
  exit
end

s = Time.now
spreadsheets.each do |spreadsheet|
  book = XLS::Book.new(spreadsheet, {:visible  => false,
                                     :continue => opt[:continue],
                                     :pagecount => opt[:pagecount] }
                                     )
  book.each do |sheet|
  puts '---' + sheet.name + '---'
    sheet.each do |record|
      record.each do |cell|
         puts "\t#{cell.header}=#{cell.value}"
      end
    end
  end  
 end
 puts Time.now - s