require 'spec'
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/..')
require 'depot'

SITE = Depot::Depot.new
at_exit {SITE.close_browser_and_raise_if nil}

World do
  SITE
end
