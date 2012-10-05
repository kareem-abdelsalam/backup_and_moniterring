namespace :db do
  desc "Dumps the database to specified folder"
  task :dump do
    require './lib/db_backer.rb'
    require 'yaml'
    db_credentials = YAML.load_file('./config/database.yml')
    # Main dumping 
    db_credentials["database"].each do |database|
      puts "starting #{database}"
      db_backer = DBBacker.new
      filename = db_backer.dump(db_credentials["username"], db_credentials["password"], database , db_credentials["dump_path"])
      puts "finished db dumping"
    end
  end
end 