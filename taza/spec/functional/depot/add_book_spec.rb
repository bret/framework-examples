
require 'spec/spec_helper'
require 'depot'

describe "Depot Application" do
  before do
    Depot::Depot.reset_database
  end
  it "should allow a book to be added to the catalog" do
    Depot.new do |depot|
      # not sure how to do this with reference to url in depot.yml
      depot.browser.goto 'http://localhost:3000/admin/new'
      
    end
  end
end