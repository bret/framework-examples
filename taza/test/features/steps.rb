library = File.expand_path(File.dirname(__FILE__) + '/../../lib')
Dir.chdir library do
  Dir["steps/*.rb"].each {|f| require f}
end