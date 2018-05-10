require 'dotenv'
Dotenv.load('.env.local')
require './pg_connection.rb'
require './mysql_connection.rb'
require 'csv'
require 'benchmark'

class WriteMetrics
  TABLE_NAMES = [:users, :organization_members, :followers, :projects, :watchers, :project_members, :commits, :repo_milestones, :repo_labels, :project_languages, :project_topics, :commit_comments, :commit_parents, :project_commits, :pull_requests, :pull_request_comments, :pull_request_commits, :pull_request_history, :issues, :issue_labels, :issue_comments, :issue_events].freeze
  
  def initialize(db_adapter = 'pg', timestamp)
    options = { host: ENV["#{db_adapter.upcase}_DB_HOST"],
                username: ENV["#{db_adapter.upcase}_DB_USERNAME"],
                password: ENV["#{db_adapter.upcase}_DB_PASSWORD"],
                dbname: ENV["#{db_adapter.upcase}_DB_NAME"],
                port: ENV["#{db_adapter.upcase}_DB_PORT"] }
    
    conn_class = db_adapter == 'mysql' ? MySQLConnection : PGConnection
    @conn = conn_class.new(options)
    @db_adapter = db_adapter
    @timestamp = timestamp
    @directory_name = "data/results/#{@timestamp}"
    Dir.mkdir(@directory_name) unless File.exists?(@directory_name)
  end
  
  def generate
    truncate_tables
    generate_write_metrics_csv
  end
  
  private
  
  def truncate_tables
    TABLE_NAMES.each { |table_name| @conn.truncate(table_name.to_s) }
  end
  
  def generate_write_metrics_csv
    source_csv = CSV.read("data/source/#{@timestamp}/queries.csv", headers: true)
    queries = source_csv['Query']
    total_time_taken = 0
    
    CSV.open("#{@directory_name}/#{@db_adapter}_write.csv", 'wb') do |csv|
      csv << ['Query', 'Time Taken in seconds']
      
      queries.each do |query|
        query_index = source_csv['Query'].find_index(query)
        table_name = source_csv['Table Name'][query_index]

        @conn.disable_trigger(table_name.to_s) if table_name.to_sym == :projects

        query = query.gsub("'f'", "0").gsub("'t'", "1") if @conn.class == MySQLConnection
        time_taken = Benchmark.realtime { @conn.execute(query) }

        @conn.enable_trigger(table_name.to_s) if table_name.to_sym == :projects
        total_time_taken = total_time_taken + time_taken
        csv << [query, time_taken]
      end
      csv << ['Total Time Taken in seconds', total_time_taken]
    end
    generate_total_execution_time_csv(queries.length, total_time_taken)
  end
  
  def generate_total_execution_time_csv(count, time)
    filename = 'data/results/write.csv'

    CSV.open(filename, 'a+') do |csv|
      csv << ['Database', 'Query count', 'Total Time Taken in millisecond'] if CSV.read(filename).empty?
      csv << [@db_adapter, count, time * 1000]
    end
  end
end
