$LOAD_PATH.unshift File.dirname(__FILE__) if $0 == __FILE__
require 'optparse'

# Handle login/host information
continue = false
opt = Hash.new
opt[:pagecount]    = false
opt[:continue]     = false
opt[:fixture_path] = nil
opt[:results_path] = 'results'

parser = OptionParser.new do |cli|
  cli.banner += " [file(s) ...]"
  cli.on('-c','--continue [bookmark]', 'Continue spreadsheet from last checkpoint or designated bookmark') { |opt[:continue]|; opt[:continue] = true if !opt[:continue]}
  cli.on('-p','--pagecount [numpages]', 'Number of pages to process')  { |opt[:pagecount]|}
  cli.on('-f','--fixture-path [path]', 'Location of test fixtures')  { |opt[:fixture_path]|}
  cli.on('-r','--results-path [path]', 'Location of test results')  { |opt[:fixture_path]|}
  cli.on('--help', 'Show the detailed help and quit') { opt[:help] = true  }
end

# Parse the commandline args
parser.parse!(ARGV)

if opt[:help]
  puts parser.help 
  exit
end

# Report all errors together
errmsg = String.new

# Collect the spreadsheets and make sure the files exist
ARGV.options = nil
spreadsheet = ARGV[0]
if ! errmsg.empty? || !spreadsheet 
  puts parser.help
  puts errmsg
  exit
end



options = {
  :visible      => false,
  :continue     => opt[:continue],
  :pagecount    => opt[:pagecount],
  :fixture_path => opt[:fixture_path],
  :results_path => opt[:results_path],
} 

if opt[:fixture_path]
  require 'lib/fixture'
  runner = Spreadsheet::FixtureRunner.new
  runner.add(spreadsheet, options)
  runner.execute
else
  require 'lib/spreadsheet'
  book = Spreadsheet::Book.new(spreadsheet, options)
  book.each do |sheet|
    puts '---' + sheet.name + '---'
    puts sheet.to_s
    sheet.each do |record|
      record.each do |cell|
         puts "\t#{cell.header}=#{cell.value}"
      end
    end
  end  
end
