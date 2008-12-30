require 'rubygems'

module Depot
  class Depot < ::Taza::Site
    def login_flow(params={})
      browser.goto 'http://localhost:3000/login/login'
      login_page do |page|
        page.user_name.set params[:name]
        page.password.set params[:password]
        page.login_button.click
      end
    end
  end
end
