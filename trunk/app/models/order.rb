#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
# An Order contains details of the purchaser and
# has a set of child LineItem rows.

class Order < ActiveRecord::Base

  has_many :line_items

  # A list of the types of payments we accept. The key is
  # the text displayed in the selection list, and the
  # value is the string that goes into the database.
  PAYMENT_TYPES = [
    [ "Check",          "check" ], 
    [ "Credit Card",    "cc"    ],
    [ "Purchase Order", "po"    ]
  ].freeze

  validates_presence_of :name, :email, :address, :pay_type
  
  # Return a count of all orders pending shipping.
  def self.count_pending
    count("shipped_at is null")
  end

  # Return all orders pending shipping.
  def self.pending_shipping
    find(:all, :conditions => "shipped_at is null")
  end


  # The shipped_at column is +NULL+ for
  # unshipped orders, the dtm of shipment otherwise.
  def mark_as_shipped
    self.shipped_at = Time.now
  end
end
