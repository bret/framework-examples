# put the base directory in the load path
top_dir = File.join(File.dirname(__FILE__), '..', '..')
$LOAD_PATH << top_dir

Dir.chdir top_dir
tests = Dir['test/spreadsheet/*spreadsheet.rb']
tests.each {|test| require test }
