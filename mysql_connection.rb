require 'mysql'

class MySQLConnection
  def initialize(options={})
    #Mysql.new(@host, @user, @pass, @db, @port, @sock, @flag)
    @conn = Mysql.new(options[:host], options[:username], options[:password], options[:dbname])
  end
  
  def execute(query)
    @conn.query(query)
  end

  def truncate(table_name)
    disable_trigger
    @conn.query("truncate #{table_name};")
    enable_trigger
  end

  def disable_trigger(table_name=nil)
    @conn.query('SET FOREIGN_KEY_CHECKS = 0;')
  end
  
  def enable_trigger(table_name=nil)
    @conn.query('SET FOREIGN_KEY_CHECKS = 1;')
  end
end
