require 'rake/testtask'

desc 'Run tests to purchase books.'
task :purchase_books do |t|
 sh 'rasta Purchase_Book.xls -f fixtures'
end

desc 'Run tests to add books to product list.'
task :add_books => :reset_db do |t|
 sh 'rasta Add_Book_to_product_list.xls -f fixtures'
end

task :reset_db do
  Dir.chdir File.dirname(__FILE__) + '/../../depot' do
    unless system 'mysql -u root -ppassword depot_development < db\product_data.sql'
      raise 'database error'
    end
  end
end

desc 'Run all tests.'
task :all => [:purchase_books, :add_books]

task :default => :purchase_books