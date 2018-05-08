require 'dotenv'
Dotenv.load('.env.local')
require './pg_connection.rb'
require './mysql_connection.rb'
require 'benchmark'

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
  
  def generate(max_limit = 10)
    truncate_tables(TABLE_NAMES)
    prepare_insert_queries(max_limit)
    puts @query_list.values.collect{|c| c[:source_query]}
    @query_list.each do |table_name, data|
      time_taken = 0
      data[:insert_statements].each do |statement|
        time_taken += Benchmark.realtime { @conn.execute(statement) }
      end
      data[:time_taken] = time_taken
    end
    @query_list
  end

  
 
  private

  def truncate_tables(names)
    names.each { |table_name| @conn.truncate(table_name.to_s) }
  end
  
  def prepare_insert_queries(max_limit)
    max_user_id = max_id("select id from users", max_limit)

    @query_list[:users][:source_query] = "select * from users limit #{max_limit};"
    @query_list[:organization_members][:source_query] = "select * from organization_members where org_id <= #{max_user_id} and user_id <= #{max_user_id} limit #{max_limit};"
    @query_list[:followers][:source_query] = "select * from followers where follower_id <= #{max_user_id} and user_id <= #{max_user_id} limit #{max_limit};"

    forked_project_join = "left join projects FP on FP.id = P.forked_from"
    max_project_id = max_id("select P.id from projects P #{forked_project_join} where P.owner_id <= #{max_user_id} and (FP.owner_id is null or FP.owner_id <= #{max_user_id})", max_limit)
    forked_project_join_conditions = "(FP.owner_id is null or FP.owner_id <= #{max_user_id} and FP.forked_from < #{max_project_id})"

    @query_list[:projects][:source_query] = [
      "select P.* from projects P #{forked_project_join} where P.owner_id <= #{max_user_id} and (P.forked_from is null or P.forked_from <= #{max_project_id} and P.forked_from <= P.id) and P.id <= #{max_project_id} and #{forked_project_join_conditions};",
      "select P.* from projects P #{forked_project_join} where P.owner_id <= #{max_user_id} and (P.forked_from <= #{max_project_id} and P.forked_from > P.id) and P.id <= #{max_project_id} and #{forked_project_join_conditions};"]
    
    @query_list[:watchers][:source_query] = "select W.* from watchers W inner join projects P on P.id = W.repo_id #{forked_project_join} where W.user_id <= #{max_user_id} and W.repo_id <= #{max_project_id} and P.owner_id <= #{max_user_id} and #{forked_project_join_conditions} limit #{max_limit};"

    @query_list[:project_members][:source_query] = "select PM.* from project_members PM inner join projects P on P.id = PM.repo_id #{forked_project_join} where PM.user_id <= #{max_user_id} and PM.repo_id <= #{max_project_id} and P.owner_id <= #{max_user_id} and #{forked_project_join_conditions} limit #{max_limit};"

    commit_conditions = "C.author_id <= #{max_user_id} and C.committer_id <= #{max_user_id} and (C.project_id is null or C.project_id <= #{max_project_id}) and (P.owner_id is null or P.owner_id <= #{max_user_id}) and #{forked_project_join_conditions}"
    max_commit_id = max_id("select C.id from commits C left join projects P on P.id = C.project_id #{forked_project_join} where #{commit_conditions}", max_limit)

    @query_list[:commits][:source_query] = "select C.* from commits C left join projects P on P.id = C.project_id #{forked_project_join} where #{commit_conditions} and C.id <= #{max_commit_id};"
    @query_list[:repo_milestones][:source_query] = "select RM.* from repo_milestones RM inner join projects P on P.id = RM.repo_id #{forked_project_join} where RM.repo_id <= #{max_project_id} and P.owner_id <= #{max_user_id} and #{forked_project_join_conditions} limit #{max_limit};"

    label_conditions = "RL.repo_id <= #{max_project_id} and P.owner_id <= #{max_user_id} and #{forked_project_join_conditions}"
    max_label_id =  max_id("select RL.id from repo_labels RL inner join projects P on P.id = RL.repo_id #{forked_project_join} where #{label_conditions}", max_limit)
    
    @query_list[:repo_labels][:source_query] = "select RL.* from repo_labels RL inner join projects P on P.id = RL.repo_id #{forked_project_join} where #{label_conditions} and RL.id < #{max_label_id};"
    @query_list[:project_languages][:source_query] = "select PL.* from project_languages PL inner join projects P on P.id = PL.project_id #{forked_project_join} where PL.project_id <= #{max_project_id} and P.owner_id <= #{max_user_id} and #{forked_project_join_conditions} limit #{max_limit};" 
    @query_list[:project_topics][:source_query] = "select PT.* from project_topics PT inner join projects P on P.id = PT.project_id #{forked_project_join} where PT.project_id <= #{max_project_id} and P.owner_id <= #{max_user_id} and #{forked_project_join_conditions} limit #{max_limit};" 
    @query_list[:commit_comments][:source_query] = "select * from commit_comments where user_id <= #{max_user_id} and commit_id <= #{max_commit_id} limit #{max_limit};" 
    @query_list[:commit_parents][:source_query] = "select * from commit_parents where parent_id <= #{max_commit_id} and commit_id <= #{max_commit_id} limit #{max_limit};" 
    @query_list[:project_commits][:source_query] = "select PC.* from project_commits PC inner join projects P on P.id = PC.project_id #{forked_project_join} where PC.project_id <= #{max_project_id} and PC.commit_id <= #{max_commit_id} and P.owner_id <= #{max_user_id} and #{forked_project_join_conditions} limit #{max_limit};" 
    
    pull_request_conditions = "(head_repo_id is null or head_repo_id <= #{max_project_id}) and base_repo_id <= #{max_project_id} and (head_commit_id is null or head_commit_id <= #{max_commit_id}) and base_commit_id <= #{max_commit_id}"
    max_pull_request_id =  max_id("select id from pull_requests PR where #{pull_request_conditions}", max_limit)

    @query_list[:pull_requests][:source_query] = "select * from pull_requests where #{pull_request_conditions} and id <= #{max_pull_request_id};"
    @query_list[:pull_request_comments][:source_query] = "select * from pull_request_comments where user_id <= #{max_user_id} and commit_id <= #{max_commit_id} and pull_request_id <= #{max_pull_request_id} limit #{max_limit};"
    @query_list[:pull_request_commits][:source_query] = "select * from pull_request_commits where commit_id <= #{max_commit_id} and pull_request_id <= #{max_pull_request_id} limit #{max_limit};"
    @query_list[:pull_request_history][:source_query] = "select * from pull_request_history where (actor_id is null or actor_id <= #{max_user_id}) and pull_request_id <= #{max_pull_request_id} limit #{max_limit};"

    issue_conditions = "assignee_id <= #{max_user_id} and pull_request_id <= #{max_pull_request_id} and reporter_id <= #{max_user_id} and repo_id <= #{max_project_id}"
    max_issue_id = max_id("select id from issues where #{issue_conditions}", max_limit)
    
    @query_list[:issues][:source_query] = "select * from issues where #{issue_conditions} and id <= #{max_issue_id};"
    @query_list[:issue_labels][:source_query] = "select * from issue_labels where label_id <= #{max_label_id} and issue_id <= #{max_issue_id} limit #{max_limit};"
    @query_list[:issue_comments][:source_query] = "select * from issue_comments where user_id <= #{max_user_id} and issue_id <= #{max_issue_id} limit #{max_limit};"
    @query_list[:issue_events][:source_query]= "select * from issue_events where actor_id <= #{max_user_id} and issue_id <= #{max_issue_id} limit #{max_limit};"
    
    @query_list.each do |table_name, data|
      data[:insert_statements] = prepare_insert_statements(table_name, data[:source_query])
      data[:count] = data[:insert_statements].count
    end
    @query_list
  end

  def max_id(query, max_limit)
    @source_conn.execute("select max(id) from (#{query} order by id limit #{max_limit}) as T;").first['max'] || 0
  end
  
  def prepare_insert_statements(table_name, source_query)
    source_query = source_query.is_a?(String) ? [source_query] : source_query
    source_data = []
    source_query.each { |q| source_data += @source_conn.execute(q).collect{ |attributes| attributes.values.map{|val| val.gsub("'", %q(\\\')) if val} } }
    source_data.collect{|values| "INSERT INTO #{table_name.to_s} VALUES('#{values.join("','")}');".gsub("''", 'null').gsub("\\'", "''") }
  end

  def csv_report(data={})
  end
end
