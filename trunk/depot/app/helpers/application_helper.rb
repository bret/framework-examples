#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
# Global helper methods for views.
module ApplicationHelper

  # Format a float as $123.45
  def fmt_dollars(amt)
    sprintf("$%0.2f", amt)
  end
end
