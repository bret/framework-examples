#---
# Excerpted from "Agile Web Development with Rails"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
require "digest/sha1"

# A User is used to validate administrative staff. The class is
# complicated by the fact that on the application side it
# deals with plain-text passwords, but in the database it uses
# SHA1-hashed passwords.

class User < ActiveRecord::Base

  # The plain-text password, which is not stored
  # in the database
  attr_accessor :password

  # We never allow the hashed password to be
  # set from a form
  attr_accessible :name, :password

  validates_uniqueness_of :name
  validates_presence_of   :name, :password


  # Return the User with the given name and
  # plain-text password
  def self.login(name, password)
    hashed_password = hash_password(password || "")
STDERR.puts hashed_password
    find(:first,
         :conditions => ["name = ? and hashed_password = ?", 
                          name, hashed_password])
  end

  # Log in if the name and password (after hashing)
  # match the database, or if the name matches
  # an entry in the database with no password
  def try_to_login
    User.login(self.name, self.password) ||
    User.find_by_name_and_hashed_password(name, "")
  end

  # When a new User is created, it initially has a
  # plain-text password. We convert this to an SHA1 hash
  # before saving the user in the database.
  def before_create
    self.hashed_password = User.hash_password(self.password)
  end

  before_destroy :dont_destroy_dave

  # Don't delete 'dave' from the database
  def dont_destroy_dave
    raise "Can't destroy dave" if self.name == 'dave'
  end

  # Clear out the plain-text password once we've
  # saved this row. This stops it being made available
  # in the session
  def after_create
    @password = nil
  end

  private

  def self.hash_password(password)
    Digest::SHA1.hexdigest(password)
  end
end

