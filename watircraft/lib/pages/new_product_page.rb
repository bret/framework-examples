require 'rubygems'
require 'taza/page'

module Depot
  class NewProductPage < ::Taza::Page
    url 'admin/new'
    field(:title) {browser.text_field(:id, 'product_title')}
    field(:description) {browser.text_field(:id, 'product_description')}
    field(:image_url) {browser.text_field(:id, 'product_image_url')}
    field(:price) {browser.text_field(:id, 'product_price')}
    element(:create_button) {browser.button(:value, 'Create')}
  end
end
