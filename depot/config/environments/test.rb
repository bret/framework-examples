#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
Dependencies.mechanism                             = :require
ActionController::Base.consider_all_requests_local = true
ActionController::Base.perform_caching             = false
ActionMailer::Base.delivery_method                 = :test