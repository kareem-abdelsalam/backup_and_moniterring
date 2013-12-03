require 'yaml'
require 'eventmachine'
require 'rufus/scheduler'
require 'zip/zip'
require './lib/db_backer'
require 'aws'
require './lib/s3_saver'

db_credentials = YAML.load_file('./config/database.yml')
s3_credentials = YAML.load_file('./config/s3.yml')

EM.run do
  scheduler = Rufus::Scheduler::EmScheduler.start_new

  scheduler.every '1d' do

    db_credentials["database"].each do |database|
      # Main dumping 
      puts "starting"
      db_backer = DBBacker.new
      filename = db_backer.dump(db_credentials["username"], db_credentials["password"], database, db_credentials["dump_path"])
      puts "finished db dumping"    

      unless filename.nil?
        S3Save.zip_and_upload(filename, "#{db_credentials["dump_path"] + filename}_dump.sql", s3_credentials["access_key_id"], s3_credentials["secret_access_key"], s3_credentials["bucket"])
      end
    end
  end
end