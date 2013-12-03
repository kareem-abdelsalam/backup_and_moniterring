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

  desc "Uploads zip file of db dump to s3"
  task :s3_backup do
    require './lib/s3_saver.rb'
    require 'yaml'
    s3_credentials = YAML.load_file('./config/s3.yml')
    db_credentials = YAML.load_file('./config/database.yml')

    files_to_backup = Dir["#{db_credentials['dump_path']}*.sql"]
    puts files_to_backup
    files_to_backup.each do |db_dump|
      file_name = db_dump[(db_dump.rindex('/') + 1)..(db_dump.rindex('_') - 1)]
      S3Saver.zip_and_upload(file_name, db_dump, s3_credentials["access_key_id"], s3_credentials["secret_access_key"], s3_credentials["bucket"])
    end
  end
end 