require 'zip/zip'
require 'aws'


module S3Saver

  def self.zip_and_upload(file_name, file_path, s3_access_key_id, s3_secret_access_key, s3_bucket)
    puts "starting zipping"
    zipfile_name = "./tmp/#{file_name}.zip"
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) {|zipfile| zipfile.add("#{file_name}_dump.sql", file_path)}
    puts "finished zipping"

    puts "starting s3 upload"
    s3 = Aws::S3.new(s3_access_key_id, s3_secret_access_key)
    bucket = s3.bucket(s3_bucket)
    key = Aws::S3::Key.new(bucket, "db_backups/#{file_name}.zip")
    key.put(File.open(zipfile_name))
    puts "finished s3 upload"

    puts "starting file delete"
    File.delete(zipfile_name)
    puts "finished file delete"
  end
end