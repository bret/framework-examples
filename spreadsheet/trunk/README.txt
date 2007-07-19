EXAMPLE
======

Running a simple example using the fixture

  runxls.rb examples/column_fixture.xls -f examples/fixtures

Running a simple example using the spreadsheet lib

  runxls.rb examples/spreadsheet_parsing.xls
  
  
--help gives other options which control where and how much of the 
spreadsheet to parse


TODO 
====

GENERAL
- Add rake for tests and gem creation
- overview docs

SPREADSHEET
- Testcases
- Doc cleanup
- Add excel cell validation (I ave a start on this)
- Work out best way to support comments in clear-colored cells
- maybe flash cell (if possible) for spreadsheet errors
  may be a way to change how the cell values are read in -> investigate

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
- Doc cleanup