namespace :db do
  desc "Dumps the database to specified folder"
  task :dump => :environment do
    require './lib/*.rb'
    require ''
    db_credentials = Rails.configuration.database_configuration[Rails.env]
    db_backer = DBBacker.new
    db_backer.dump(db_credentials["username"], db_credentials["password"], db_credentials["database"] ,"/usr/local/db_dumps/")
  end
end 