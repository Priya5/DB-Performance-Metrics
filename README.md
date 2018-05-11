# Database Performance Metrics

## Requirements

* Ruby
* Bundler

This application uses a `.env.local` file to store database credentials. After cloning the repository, create a `.env.local` file in the root folder (`/DB-Performance-Metrics`) and copy the contents of `.env` file. Then, provide the values of the database configuration.

```bash
SOURCE_DB_HOST = 
SOURCE_DB_NAME = 
SOURCE_DB_USERNAME = 
SOURCE_DB_PASSWORD = 
SOURCE_DB_PORT = 

PG_DB_HOST = 
PG_DB_NAME = 
PG_DB_USERNAME = 
PG_DB_PASSWORD = 
PG_DB_PORT = 

MYSQL_DB_HOST = 
MYSQL_DB_NAME = 
MYSQL_DB_USERNAME = 
MYSQL_DB_PASSWORD =
MYSQL_DB_PORT =
```

## Running the app

```ruby
bundle install
ruby generate_metrics
```

```ruby
ruby generate_metrics source_db_record_fetch_limit
```

Here, `source_db_record_fetch_limit` is a integer value for setting the max limit of records fetched from source database to populate the destination(MySQL/PostgreSQL) database.

Once the above command is executed, it will generated csv in '/DB-Performance-Metrics/data/results' directory which will have the write and read times of MySQL and PostgreSQL. 
