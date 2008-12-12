require 'rake/testtask'

desc 'Run tests to purchase books.'
task :purchase_books do |t|
 sh 'rasta Purchase_Book.xls -f fixtures'
end

desc 'Run tests to add books to product list.'
task :add_books do |t|
 sh 'rasta Add_Book_to_product_list.xls -f fixtures'
end

desc 'Run all tests.'
task :all => [:purchase_books, :add_books]
