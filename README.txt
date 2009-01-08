The project presents sample test suites for several testing frameworks. Each
of the examples is a test suite for Depot, a rails application.

We have been using this project to both explore the features and benefits of 
existing frameworks as well as to drive improvements and integration. 

Specifically the taza suite is being used to drive development of the 
taza/watircraft branch of development.


Running the sample application (Depot)

This applications uses Rails 1.2 and MySQL 5.0. 
See depot/README.txt for details.


Running tests

install ruby 186-26
gem update --system
gem install watir cucumber rspec win32console roo rasta taza

In each test directory, run:
rake -f <Rakefile>
where <Rakefile> is replaced with the name of the Rakefile eg Rakefile, rakefile.rb etc

The rasta tests will only run on Windows.