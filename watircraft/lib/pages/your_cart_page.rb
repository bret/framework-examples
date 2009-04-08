require 'rubygems'
require 'taza/page'

module Depot
  class YourCartPage < ::Taza::Page
    url 'store/display_cart'
    element(:items_table) {@browser.table(:index, 1)}
    table(:items) do
      field(:quantity) {@row.cell(:index, 1)}
      field(:description) {@row.cell(:index, 2)}
      field(:price_each) {@row.cell(:index, 3)}
      field(:price_total) {@row.cell(:incex, 4)}
    end
    field(:total) {@browser.cell(:id, 'totalcell')}
  end
end
