require 'rubygems'
require 'taza/page'

module Depot
  class NewProductPage < ::Taza::Page
    element(:title) {browser.text_field(:id, 'product_title')}
    element(:description) {browser.text_field(:id, 'product_description')}
    element(:image_url) {browser.text_field(:id, 'product_image_url')}
    element(:price) {browser.text_field(:id, 'product_price')}
    element(:create_button) {browser.button(:value, 'Create')}
  end
end
