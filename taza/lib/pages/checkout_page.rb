require 'rubygems'
require 'taza/page'

module Depot
  class CheckoutPage < ::Taza::Page
    
    element(:name_field){browser.text_field(:id, 'order_name')}
  end
end
