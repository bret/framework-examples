require 'rubygems'
require 'taza/page'

module Depot
  class ProductListingPage < ::Taza::Page
    url 'admin/list'
    element(:show_link) do |title| 
      span = @browser.span(:class => 'ListTitle', :text => title)
      row = span.parent.parent
      action_cell = row.cell(:class => 'ListActions')
      action_cell.link(:text => 'Show')
    end
  end
end
