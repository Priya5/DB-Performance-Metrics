require 'pg'

class PGConnection
  def initialize(options={})
    @conn = PG.connect(dbname: options[:dbname], host: options[:host], port: options[:port], user: options[:username], password: options[:password])
  end

  def execute(query)
    @conn.exec(query)
  end

  def truncate(table_name)
    @conn.exec("truncate #{table_name} RESTART IDENTITY cascade;")
  end

  def disable_trigger(table_name)
    @conn.exec("ALTER TABLE #{table_name} DISABLE TRIGGER all;")
  end

  def enable_trigger(table_name)
    @conn.exec("ALTER TABLE #{table_name} ENABLE TRIGGER all;")
  end
end
