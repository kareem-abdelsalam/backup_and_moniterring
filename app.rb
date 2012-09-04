require 'yaml'
require 'eventmachine'
require 'rufus/scheduler'
require 'zip/zip'
require './lib/db_backer'
require 'aws'

db_credentials = YAML.load_file('./config/database.yml')
s3_credentials = YAML.load_file('./config/s3.yml')

EM.run do
  scheduler = Rufus::Scheduler::EmScheduler.start_new

  scheduler.every '1d' do

    # Main dumping 
    puts "starting"
    db_backer = DBBacker.new
    filename = db_backer.dump(db_credentials["username"], db_credentials["password"], db_credentials["database"] , db_credentials["dump_path"])
    puts "finished db dumping"    

    # File zipping
    puts "starting zipping"
    zipfile_name = "./tmp/#{filename}.zip"
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) {|zipfile| zipfile.add("#{filename}_dump.sql", "#{db_credentials["dump_path"] + filename}_dump.sql")}
    puts "finished zipping"

    puts "starting s3 upload"
    s3 = Aws::S3.new(s3_credentials["access_key_id"], s3_credentials["secret_access_key"])
    bucket = s3.bucket(s3_credentials["bucket"])
    key = Aws::S3::Key.new(bucket, "db_backups/#{filename}.zip")
    puts key.exists?
    key.put(File.open(zipfile_name))
    puts key.exists?
    puts "finished s3 upload"

    puts "starting file delete"
    File.delete(zipfile_name)
    puts "finished file delete"
  end
end