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
    @conn.query('SET FOREIGN_KEY_CHECKS = 0;')
    @conn.query("truncate #{table_name} commits RESTART IDENTITY cascade;")
    @conn.query('SET FOREIGN_KEY_CHECKS = 1;')
  end
end
