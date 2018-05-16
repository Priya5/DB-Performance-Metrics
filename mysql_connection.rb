require 'mysql2'

class MySQLConnection
  def initialize(options={})
    @conn = Mysql2::Client.new(database: options[:dbname], host: options[:host], port: options[:port], username: options[:username], password: options[:password])
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
