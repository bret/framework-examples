#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
# This controller performs double duty. It contains the
# #login action, which is used to log in administrative users.
#
# It also contains the #add_user, #list_users, and #delete_user
# actions, used to maintain the users table in the database.
#
# The LoginController shares a layout with AdminController
#
# See also: User

class LoginController < ApplicationController

  layout "admin"

  # You must be logged in to use all functions except #login
  before_filter :authorize, :except => :login

  # The default action displays a status page.
  def index
    @total_orders   = Order.count
    @pending_orders = Order.count_pending
  end

  # Display the login form and wait for user to
  # enter a name and password. We then validate
  # these, adding the user object to the session
  # if they authorize. 
  def login
    if request.get?
      session[:user_id] = nil
      @user = User.new
    else
      @user = User.new(params[:user])
      logged_in_user = @user.try_to_login

      if logged_in_user
        session[:user_id] = logged_in_user.id
        redirect_to(:action => "index")
      else
        flash[:notice] = "Invalid user/password combination"
      end
    end
  end
  
  # Add a new user to the database.
  def add_user
    if request.get?
      @user = User.new
    else
      @user = User.new(params[:user])
      if @user.save
        redirect_to_index("User #{@user.name} created")
      end
    end
  end

  # Delete the user with the given ID from the database.
  # The model raises an exception if we attempt to delete
  # the last user.
  def delete_user
    id = params[:id]
    if id && user = User.find(id)
      begin
        user.destroy
        flash[:notice] = "User #{user.name} deleted"
      rescue
        flash[:notice] = "Can't delete that user"
      end
    end
    redirect_to(:action => :list_users)
  end

  # List all the users.
  def list_users
    @all_users = User.find(:all)
  end

  # Log out by clearing the user entry in the session. We then
  # redirect to the #login action.
  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end
end
