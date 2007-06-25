#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
# A Product is something we can sell (but only if
# we're past its +date_available+ attribute).
class Product < ActiveRecord::Base

  validates_presence_of     :title
  validates_presence_of     :description
  validates_presence_of     :image_url
  validates_uniqueness_of   :title
  validates_numericality_of :price
  validates_format_of       :image_url, 
                            :with    => %r{^http:.+\.(gif|jpg|png)$}i,
                            :message => "must be a URL for a GIF, JPG, or PNG image"

  # Return a list of products we can sell (which means they have to be
  # available). Show the most recently available first.
  def self.salable_items
    find(:all,
         :conditions => "date_available <= now()", 
         :order      => "date_available desc")
  end

  protected

  # Validate that the product price is a positive Float.
  def validate  #:doc:
    errors.add(:price, "should be positive") unless price.nil? || price > 0.0
  end

end

