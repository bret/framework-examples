require 'rubygems'
require 'taza/page'

module Depot
  class ShowProductPage < ::Taza::Page
    url 'admin/show/\d+'
    def title
      text_displayed 1
    end
    def description
      text_displayed 2
    end
    def image_url
      text_displayed 3
    end
    def price
      text_displayed 4
    end
    private
    def text_displayed index
      para = @browser.div(:id => 'main').p(:index => index)
      bold_text = para.b(:index => 1).text
      para.text.sub(/^#{bold_text}/, '').strip      
    end
  end
end
