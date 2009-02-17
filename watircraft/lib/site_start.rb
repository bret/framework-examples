require 'initialize'
require 'depot'

SITE = Depot::Depot.new
at_exit {SITE.close}

require 'spec/expectations'
START = SITE.execution_context
START.extend Spec::Expectations      