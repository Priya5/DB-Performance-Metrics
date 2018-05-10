require 'dotenv'
Dotenv.load('.env.local')
require './pg_connection.rb'
require './mysql_connection.rb'
require 'csv'
require 'benchmark'

class ReadMetrics
  def initialize(db_adapter = 'pg', timestamp)
    options = { host: ENV["#{db_adapter.upcase}_DB_HOST"],
                username: ENV["#{db_adapter.upcase}_DB_USERNAME"],
                password: ENV["#{db_adapter.upcase}_DB_PASSWORD"],
                dbname: ENV["#{db_adapter.upcase}_DB_NAME"],
                port: ENV["#{db_adapter.upcase}_DB_PORT"] }
    
    conn_class = db_adapter == 'mysql' ? MySQLConnection : PGConnection
    @conn = conn_class.new(options)
    @db_adapter = db_adapter
    @directory_name = "data/results/#{timestamp}"
    Dir.mkdir(@directory_name) unless File.exists?(@directory_name)
  end
  
  def generate
    source_csv = CSV.read("data/source/read_queries.csv", headers: true)
    queries = source_csv['Query']
    total_time_taken = 0
    
    CSV.open("#{@directory_name}/#{@db_adapter}_read.csv", 'wb') do |csv|
      csv << ['Query', 'Time Taken in seconds']
      
      queries.each do |query|
        time_taken = Benchmark.realtime { @conn.execute(query) }
        total_time_taken = total_time_taken + time_taken
        csv << [query, time_taken]
      end
      csv << ['Total Time Taken in seconds', total_time_taken]
    end
    generate_total_execution_time_csv(queries.length, total_time_taken)
  end
  
  def generate_total_execution_time_csv(count, time)
    filename = 'data/results/read.csv'
    
    CSV.open(filename, 'a+') do |csv|
      csv << ['Database', 'Query count', 'Total Time Taken in millisecond'] if CSV.read(filename).empty?
      csv << [@db_adapter, count, time * 1000]
    end
  end
end
