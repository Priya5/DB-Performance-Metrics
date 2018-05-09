require 'dotenv'
Dotenv.load('.env.local')
require './pg_connection.rb'
require './mysql_connection.rb'
require 'benchmark'
require 'byebug'

class WritePerformance
  TABLE_NAMES = [:users, :organization_members, :followers, :projects, :watchers, :project_members, :commits, :repo_milestones, :repo_labels, :project_languages, :project_topics, :commit_comments, :commit_parents, :project_commits, :pull_requests, :pull_request_comments, :pull_request_commits, :pull_request_history, :issues, :issue_labels, :issue_comments, :issue_events].freeze
  
  def initialize(db_adapter = 'pg')
    source_options = { host: ENV["SOURCE_DB_HOST"],
                username: ENV["SOURCE_DB_USERNAME"],
                password: ENV["SOURCE_DB_PASSWORD"],
                dbname: ENV["SOURCE_DB_NAME"],
                port: ENV["SOURCE_DB_PORT"] }
    
    @source_conn = PGConnection.new(source_options)

    options = { host: ENV["#{db_adapter.upcase}_DB_HOST"],
                username: ENV["#{db_adapter.upcase}_DB_USERNAME"],
                password: ENV["#{db_adapter.upcase}_DB_PASSWORD"],
                dbname: ENV["#{db_adapter.upcase}_DB_NAME"],
                port: ENV["#{db_adapter.upcase}_DB_PORT"] }
    
    conn_class = db_adapter == 'mysql' ? MySQLConnection : PGConnection
    @conn = conn_class.new(options)
    @query_list = {}
    TABLE_NAMES.each{|table_name| @query_list[table_name] = {} }
  end
  
  def generate(max_limit = 100)
    query = nil
    truncate_tables(TABLE_NAMES)
    prepare_insert_queries(max_limit)
    @query_list.each do |table_name, data|
      @conn.disable_trigger(table_name.to_s) if table_name == :projects
      time_taken = 0
      data[:insert_statements].each do |statement|
        query = statement
        time_taken += Benchmark.realtime { @conn.execute(statement) }
      end
      data[:time_taken] = time_taken
      @conn.enable_trigger(table_name.to_s) if table_name == :projects
    end
    @query_list.collect{|k,c| [k,c[:time_taken], c[:count]] }
  rescue => error
    puts error
    puts query
  end
 
  private

  def truncate_tables(names)
    names.each { |table_name| @conn.truncate(table_name.to_s) }
  end

  def prepare_insert_queries(max_limit)
    user_ids = get_ids("select id from users", max_limit)
    @query_list[:users][:source_query] = "select * from users where id in (#{user_ids});"

    @query_list[:organization_members][:source_query] = "select * from organization_members where org_id in (#{user_ids}) and user_id in (#{user_ids}) limit #{max_limit};"
    @query_list[:followers][:source_query] = "select * from followers where follower_id in (#{user_ids}) and user_id in (#{user_ids}) limit #{max_limit};"

    project_ids = get_ids("select id from projects where owner_id in (#{user_ids})", max_limit)
    @query_list[:projects][:source_query] = "select * from projects where id in (#{project_ids});"

    @query_list[:watchers][:source_query] = "select * from watchers W where user_id in (#{user_ids}) and repo_id in (#{project_ids}) limit #{max_limit};"
    @query_list[:project_members][:source_query] = "select * from project_members where user_id in (#{user_ids}) and repo_id in (#{project_ids}) limit #{max_limit};"

    commit_ids = get_ids("select id from commits where author_id in (#{user_ids}) and committer_id in (#{user_ids}) and (project_id is null or project_id in (#{project_ids}))", max_limit)
    @query_list[:commits][:source_query] = "select * from commits where id in (#{commit_ids});"

    @query_list[:repo_milestones][:source_query] = "select * from repo_milestones where repo_id in (#{project_ids}) limit #{max_limit};"
    
    label_ids =  get_ids("select id from repo_labels where repo_id in (#{project_ids})", max_limit)
    @query_list[:repo_labels][:source_query] = "select * from repo_labels where id in (#{label_ids});"

    @query_list[:project_languages][:source_query] = "select * from project_languages where project_id in (#{project_ids}) limit #{max_limit};" 
    @query_list[:project_topics][:source_query] = "select * from project_topics where project_id in (#{project_ids}) limit #{max_limit};"
    
    @query_list[:commit_comments][:source_query] = "select * from commit_comments where user_id in (#{user_ids}) and commit_id in (#{commit_ids}) limit #{max_limit};"
    @query_list[:commit_parents][:source_query] = "select * from commit_parents where parent_id in (#{commit_ids}) and commit_id in (#{commit_ids}) limit #{max_limit};"

    @query_list[:project_commits][:source_query] = "select * from project_commits where project_id in (#{project_ids}) and commit_id in (#{commit_ids}) limit #{max_limit};" 
    
    pull_request_conditions = "(head_repo_id is null or head_repo_id in (#{project_ids})) and base_repo_id in (#{project_ids}) and (head_commit_id is null or head_commit_id in (#{commit_ids})) and base_commit_id in (#{commit_ids})"
    pull_request_ids = get_ids("select id from pull_requests where #{pull_request_conditions}", max_limit)
    @query_list[:pull_requests][:source_query] = "select * from pull_requests where id in (#{pull_request_ids});"

    @query_list[:pull_request_comments][:source_query] = "select * from pull_request_comments where user_id in (#{user_ids}) and commit_id in (#{commit_ids}) and pull_request_id in (#{pull_request_ids}) limit #{max_limit};"
    @query_list[:pull_request_commits][:source_query] = "select * from pull_request_commits where commit_id in (#{commit_ids}) and pull_request_id in (#{pull_request_ids}) limit #{max_limit};"
    @query_list[:pull_request_history][:source_query] = "select * from pull_request_history where (actor_id is null or actor_id in (#{user_ids})) and pull_request_id in (#{pull_request_ids}) limit #{max_limit};"

    issue_ids = get_ids("select id from issues where (assignee_id is null or assignee_id in (#{user_ids})) and (pull_request_id is null or pull_request_id in (#{pull_request_ids})) and (reporter_id is null or reporter_id in (#{user_ids})) and repo_id in (#{project_ids})", max_limit)
    @query_list[:issues][:source_query] = "select * from issues where id in (#{issue_ids});"

    @query_list[:issue_labels][:source_query] = "select * from issue_labels where label_id in (#{issue_ids}) and issue_id in (#{issue_ids}) limit #{max_limit};"
    @query_list[:issue_comments][:source_query] = "select * from issue_comments where user_id in (#{user_ids}) and issue_id in (#{issue_ids}) limit #{max_limit};"
    @query_list[:issue_events][:source_query]= "select * from issue_events where actor_id in (#{user_ids}) and issue_id in (#{issue_ids}) limit #{max_limit};"
    
    @query_list.each do |table_name, data|
      data[:insert_statements] = prepare_insert_statements(table_name, data[:source_query])
      data[:count] = data[:insert_statements].count
    end
    @query_list
  end

  def get_ids(query, limit)
    query = "#{query} limit #{limit}" if limit
    ids = @source_conn.execute(query).collect(&:values).join(',')
    ids.empty? ? 0 : ids
  end
  
  def prepare_insert_statements(table_name, source_query)
    data = @source_conn.execute(source_query).collect{ |attributes| attributes.values.map{|val| val.gsub("'", %q(\\\')) if val} }
    data.collect do |values|
      query = "INSERT INTO #{table_name.to_s} VALUES('#{values.join("','")}');".gsub("''", 'null').gsub("\\'", "''").gsub(/1970-01-01 [0-9]+:[0-9]+:[0-9]+/, '1970-02-01 00:00:00')
      query = query.gsub("'f'", "0").gsub("'t'", "1") if @conn.class == MySQLConnection
      query
    end
  end

  def csv_report(data={})
  end
end
