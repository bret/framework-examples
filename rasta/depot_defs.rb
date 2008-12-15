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
  def admin_login_button
    $br.button(:type, 'submit')
  end
  def new_product_create_button
    $br.button(:type, 'submit')
  end
  def admin_new_product_day_available_select_list
    $br.select_list(:id, 'product_date_available_3i')
  end
  def admin_new_product_description
    $br.text_field(:id, 'product_description')
  end
  def admin_new_product_hour_available_select_list
    $br.select_list(:id, 'product_date_available_4i')
  end
  def admin_new_product_image_url_text_field
    $br.text_field(:id, 'product_image_url')
  end
  def new_product_link
    $br.link(:text, 'New product')
  end
  def admin_new_product_minute_available_select_list
    $br.select_list(:id, 'product_date_available_5i')
  end
  def admin_new_product_month_available_select_list
    $br.select_list(:id, 'product_date_available_2i')
  end
  def admin_new_product_price_text_field
    $br.text_field(:id, 'product_price')
  end
  def admin_new_product_title
    $br.text_field(:id, 'product_title')
  end
  def admin_new_product_year_available_select_list
    $br.select_list(:id, 'product_date_available_1i')
  end
  def admin_password_field
    $br.text_field(:id, 'user_password')
  end
  def pay_using(l_select)
    $br.select_list(:id, 'order_pay_type').select"#{l_select}"
  end
  def admin_product_listing_heading
    $br.h1(:text, 'Product Listing')
  end
  def products_link
    $br.link(:text, 'Products')
  end
  def purchase_total_cell
    $br.cell(:id, 'totalcell')
  end
  def admin_new_product_title_span(l_title)
    $br.span(:text, "#{l_title}")
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
  def admin_user_name_text_field
    $br.text_field(:id, 'user_name')
  end
end
