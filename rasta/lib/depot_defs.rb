require 'watir'
require 'watir/testcase'

module Depot_Defs

  include Test::Unit::Assertions

  def goto_site(l_site)
    if $br
      $br.goto("#{l_site}")
    else
      $br = Watir::IE.new_process
#      $br.set_fast_speed
      $br.goto("#{l_site}")
    end
  end
  
  def add_book_to_cart_link(book_name)
#    l_link.gsub!(/\s/, '')
#    $br.span(:id, "#{l_link}").link(:class, 'addtocart').click
    l_parent = $br.h3(:text => "#{book_name}").parent
    l_parent.link(:class => 'addtocart').click
  end
  
  def link_by_text_click(l_text)
    $br.link(:text, "#{l_text}").click
  end
  
  def pay_using(l_select)
    $br.select_list(:id, 'order_pay_type').select"#{l_select}"
  end
  
  def purchase_total_cell
    $br.cell(:id, 'totalcell')
  end
  
  def shipping_address_text_field
    $br.text_field(:id, 'order_address')
  end
  
  def shipping_email_text_field
    $br.text_field(:id, 'order_email')
  end

  def shipping_name_text_field
    $br.text_field(:id, 'order_name')
  end

end
