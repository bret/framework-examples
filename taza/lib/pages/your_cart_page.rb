require 'rubygems'
require 'taza/page'

module Depot
  class YourCartPage < ::Taza::Page
    url 'store/display_cart'
    element(:total_element) {@browser.cell(:id, 'totalcell')}
    
    def total
      total_element.text
    end

  end
end
