TOPDIR = File.join(File.dirname(__FILE__), '..')
$LOAD_PATH.unshift TOPDIR

require 'spec'
require 'lib/spreadsheet'
require 'lib/spreadsheet_matcher'

#TODO: move options parsing here instead of
# pulling from the spreadsheet options
    
def find_class_by_name(classname)
  ObjectSpace.each_object(Class) do |klass| 
    return klass if klass.name == classname
  end
  raise ArgumentError, "Class '#{classname}' not found!"
end

module Spreadsheet
 
  class Fixture
    NONE = -4142
    GRAY = 24
    
    def initialize(sheet)
      @sheet = sheet
    end
    
    # We make an assumption that the fixture will
    # have a :run method that we can call. Beyond
    # that, the fixture itself has full control
    # of how to parse and use the data. Make things
    # go through the dispatch, however in the event
    # we want to have something done to affect all 
    # fixtures
    def dispatch
      self.run
      #@sheet.book.save
    end
  end
  
  class FixtureLoader
    attr_reader :classname
    
    def initialize(sheet, options=Hash.new)
      # We're making an assumption here
      # that the fixture filename matches the 
      # spreadsheet tab name for the fixture
      # TODO: Add error handling - also is there a better way to do this?
      require options[:fixture_path]  + '/' + sheet.name
      
      # Get a reference to the loaded class
      @classname = find_class_by_name(sheet.name)
      # error check for 
      
      fixture = @classname.new(sheet)
      fixture.dispatch
    end
    
    # Walk the object space to find the class object that
    # matches the name of the class we want to use
  end
  
  class FixtureRunner
  
    def add(spreadsheet, options = Hash.new)
      @options = options
      @options[:visible] = true if ! @options[:visible]
      workingfile = copy(spreadsheet)
      @workbooks = []
      @workbooks << Spreadsheet::Book.new(workingfile, options)
    end
    
    def copy(spreadsheet)
      path = @options[:results_path]
      # handle relative paths
      
      if File.expand_path(path) != path
        path = TOPDIR + '/' + path
      end
      path += '/' + Time.now.to_i.to_s
      FileUtils.mkdir_p(path)  if ! File.directory?(path)
      puts path
      copyfile = path + '/' + File.basename(spreadsheet)
      FileUtils.cp(spreadsheet, copyfile)
      return copyfile
    end
    
    def execute
      @workbooks.each do |book| 
        book.each do |sheet| 
          FixtureLoader.new(sheet, book.options)
        end
      end
    end
  end
end 