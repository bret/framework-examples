How to Run this Depot Application

You need to start this application before you can run the example tests.

Install Rails
1. "gem update --system"
2. "gem install rails -v 1.2.3"

Install & Configure MySQL
3. Install MySQL 5.0. Choose "Typical" Installation. 
   Select the option to add commands to your path.
4. Configure MySQL with a "Standard Configuation" Server Instance.

Load Database
5. Create database

depot>mysql -u root -p
Enter password: ********
Welcome to the MySQL monitor.  Commands end with ; or \g.
mysql> create database depot_development;
mysql> exit;

6. Create tables. 
 
depot> mysql -u root -p depot_development < db/create.sql
Enter password: ********

7. Load sample data.

depot>mysql -u root -p depot_development < db/product_data.sql
Enter password: ********

Configure and start the Application

8. Edit config/database.yml. For database depot_development, specify 
   username: root, password: password.

9. Start the server
depot>ruby script/server
=> Rails application started on http://0.0.0.0:3000
[2006-12-30 23:48:59] INFO  WEBrick 1.3.1
[2006-12-30 23:48:59] INFO  ruby 1.8.2 (2004-12-25) [i386-mswin32]
[2006-12-30 23:48:59] INFO  WEBrick::HTTPServer#start: pid=1752 port=3000

10. Open a web browser to "http://localhost:3000/store".

11. You will see several deprecation warnings. This is normal.

