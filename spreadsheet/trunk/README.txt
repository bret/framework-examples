EXAMPLE
======

Running a simple example using the fixture

  runxls.rb examples/column_fixture.xls -f examples/fixtures

Running a simple example using the spreadsheet lib

  runxls.rb examples/spreadsheet_parsing.xls
  
  
--help gives other options which control where and how much of the 
spreadsheet to parse

Rubyforge
========
has project management tools?


TODO 
====

GENERAL
- Add rake for tests and gem creation
- overview docs
- make generic layer to interface between fixture and spreadsheet
this may allow us to redirect output at another place like a DB also input 

SPREADSHEET
- Testcases
- Doc cleanup
- Add excel cell validation (I have a start on this)
- Work out best way to support comments in clear-colored cells
- maybe flash cell (if possible) for spreadsheet errors
- Allow for italicized rows/columns to skip
- Add support for ()/? for methods and strip

FIXTURE
- Testcases
- Add a class to track counts 
- Add a summary page in excel that shows page, and summary counts
- Save output file (this may take some restructuring)
- Examine the fixture to see if this is the right way to set things up
- Improve path handling for fixture location (maybe dirsearch)
- Connect to depot app for sample
- See if this is the correct way we want to use rspec..may want to run on separate thread,
  etc. See how maybe the rubyfit project handled things
 - find way to handle multiple tabs so the tests run after each tab
- Doc cleanup
- use rspec for the different outputs (xml, html, etc)
- migrations (rails activerecord equiv for schemas)
- use the rspec formatters and have them inherit the parent and create a class

RAILS APP?
- post results
