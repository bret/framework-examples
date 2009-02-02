require 'rubygems'
require 'taza/page'

module Depot
  class YourCartPage < ::Taza::Page
    url 'store/display_cart'
    field(:total) {@browser.cell(:id, 'totalcell')}
  end
end
