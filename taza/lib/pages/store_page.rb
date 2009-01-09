require 'rubygems'
require 'taza/page'

module Depot
  class StorePage < ::Taza::Page
    url 'store'
    element :add_to_cart_button do |book_title|
      title = @browser.h3(:text, book_title) 
      catalog_entry = title.parent
      catalog_entry.link(:class, 'addtocart')
    end
  end
end
