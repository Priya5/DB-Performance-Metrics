require 'dotenv'
Dotenv.load('.env.local')
require './pg_connection.rb'
require './write_metrics.rb'
require './read_metrics.rb'
require 'benchmark'
require 'csv'
require 'byebug'

class DatabaseMetrics
  def initialize(source_db_max_record_limit)
    source_options = { host: ENV["SOURCE_DB_HOST"],
                       username: ENV["SOURCE_DB_USERNAME"],
                       password: ENV["SOURCE_DB_PASSWORD"],
                       dbname: ENV["SOURCE_DB_NAME"],
                       port: ENV["SOURCE_DB_PORT"] }
    
    @source_conn = PGConnection.new(source_options)
    @limit = source_db_max_record_limit
    @current_timestamp = Time.now.to_i
    @directory_name = "data/source/csv"
    Dir.mkdir(@directory_name) unless File.exists?(@directory_name)
  end

  def generate
    generate_insert_queries_csv unless File.exists?("#{@directory_name}/#{@limit}.csv")
    generate_write_metrics
    generate_read_metrics
  end

  private

  def generate_write_metrics
    WriteMetrics.new('pg', @current_timestamp, @limit).generate
    WriteMetrics.new('mysql', @current_timestamp, @limit).generate
  end

  def generate_read_metrics
    ReadMetrics.new('pg', @current_timestamp).generate
    ReadMetrics.new('mysql', @current_timestamp).generate
  end
  
  def generate_insert_queries_csv
    CSV.open("#{@directory_name}/#{@limit}.csv", 'wb') do |csv|
      csv << ['Table Name', 'Query']
      source_queries_hash.each do |table_name, query|
        insert_statements = prepare_insert_statements(table_name, query)
        insert_statements.each do |insert_query|
          csv << [table_name, insert_query]
        end
      end
    end
  end

  def source_queries_hash
    query_list = {}
    user_ids = get_ids("select id from users", @limit)
    query_list[:users] = "select * from users where id in (#{user_ids});"
    
    query_list[:organization_members] = "select * from organization_members where org_id in (#{user_ids}) and user_id in (#{user_ids}) limit #{@limit};"
    query_list[:followers] = "select * from followers where follower_id in (#{user_ids}) and user_id in (#{user_ids}) limit #{@limit};"
    
    project_ids = get_ids("select id from projects where owner_id in (#{user_ids})", @limit)
    query_list[:projects] = "select * from projects where id in (#{project_ids});"
    
    query_list[:watchers] = "select * from watchers W where user_id in (#{user_ids}) and repo_id in (#{project_ids}) limit #{@limit};"
    query_list[:project_members] = "select * from project_members where user_id in (#{user_ids}) and repo_id in (#{project_ids}) limit #{@limit};"
    
    commit_ids = get_ids("select id from commits where author_id in (#{user_ids}) and committer_id in (#{user_ids}) and (project_id is null or project_id in (#{project_ids}))", @limit)
    query_list[:commits] = "select * from commits where id in (#{commit_ids});"
    
    query_list[:repo_milestones] = "select * from repo_milestones where repo_id in (#{project_ids}) limit #{@limit};"
    
    label_ids =  get_ids("select id from repo_labels where repo_id in (#{project_ids})", @limit)
    query_list[:repo_labels] = "select * from repo_labels where id in (#{label_ids});"
    
    query_list[:project_languages] = "select * from project_languages where project_id in (#{project_ids}) limit #{@limit};" 
    query_list[:project_topics] = "select * from project_topics where project_id in (#{project_ids}) limit #{@limit};"
    
    query_list[:commit_comments] = "select * from commit_comments where user_id in (#{user_ids}) and commit_id in (#{commit_ids}) limit #{@limit};"
    query_list[:commit_parents] = "select * from commit_parents where parent_id in (#{commit_ids}) and commit_id in (#{commit_ids}) limit #{@limit};"
    
    query_list[:project_commits] = "select * from project_commits where project_id in (#{project_ids}) and commit_id in (#{commit_ids}) limit #{@limit};" 
    
    pull_request_conditions = "(head_repo_id is null or head_repo_id in (#{project_ids})) and base_repo_id in (#{project_ids}) and (head_commit_id is null or head_commit_id in (#{commit_ids})) and base_commit_id in (#{commit_ids})"
    pull_request_ids = get_ids("select id from pull_requests where #{pull_request_conditions}", @limit)
    query_list[:pull_requests] = "select * from pull_requests where id in (#{pull_request_ids});"
    
    query_list[:pull_request_comments] = "select * from pull_request_comments where user_id in (#{user_ids}) and commit_id in (#{commit_ids}) and pull_request_id in (#{pull_request_ids}) limit #{@limit};"
    query_list[:pull_request_commits] = "select * from pull_request_commits where commit_id in (#{commit_ids}) and pull_request_id in (#{pull_request_ids}) limit #{@limit};"
    query_list[:pull_request_history] = "select * from pull_request_history where (actor_id is null or actor_id in (#{user_ids})) and pull_request_id in (#{pull_request_ids}) limit #{@limit};"
    
    issue_ids = get_ids("select id from issues where (assignee_id is null or assignee_id in (#{user_ids})) and (pull_request_id is null or pull_request_id in (#{pull_request_ids})) and (reporter_id is null or reporter_id in (#{user_ids})) and repo_id in (#{project_ids})", @limit)
    query_list[:issues] = "select * from issues where id in (#{issue_ids});"
    
    query_list[:issue_labels] = "select * from issue_labels where label_id in (#{issue_ids}) and issue_id in (#{issue_ids}) limit #{@limit};"
    query_list[:issue_comments] = "select * from issue_comments where user_id in (#{user_ids}) and issue_id in (#{issue_ids}) limit #{@limit};"
    query_list[:issue_events]= "select * from issue_events where actor_id in (#{user_ids}) and issue_id in (#{issue_ids}) limit #{@limit};"
    query_list
  end

  def get_ids(query, limit)
    query = "#{query} limit #{limit}" if limit
    ids = @source_conn.execute(query).collect(&:values).join(',')
    ids.empty? ? 0 : ids
  end
  
  def prepare_insert_statements(table_name, source_query)
    data = @source_conn.execute(source_query).collect{ |attributes| attributes.values.map {|val| val ? val.gsub("'", %q(\\\')) : 'null' } }
    data.collect { |values| "INSERT INTO #{table_name.to_s} VALUES('#{values.join("','")}');".gsub("\\'", "''").gsub("'null'", 'null').gsub(/1970-01-01 [0-9]+:[0-9]+:[0-9]+/, '1970-02-01 00:00:00') }
  end
end
