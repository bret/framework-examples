require 'rake/testtask'

desc 'Run tests to purchase books'
Rake::TestTask.new :purchase_books do |t|
 sh 'rasta Purchase_Book.xls -f fixtures'
  t.verbose = true
end

