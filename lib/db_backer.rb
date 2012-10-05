require 'cocaine'
class DBBacker
  def dump(username, password, db_name, dir)
    filename = Time.now.strftime("%Y_%m_%d_%I_%M_%S")
    if !File.exist?(dir)
      puts "create /usr/local/db_dumps as a root then run task again and make accessible to non root users.:("
      return nil  
    else
      c = Cocaine::CommandLine.new("mysqldump", "-u#{username} -p#{password} --database :database > :file",
       database: db_name, file: "#{dir + db_name}_#{filename}_dump.sql")
      c.run
      return "#{db_name}_#{filename}"
    end  
  end
end