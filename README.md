### Description

Pure ruby script to sync data from Production Database (MySQL, Postgres) to Reporting Database (MySQL, Postgres)

Using **Sequel** (and its dependencies like ruby-mysql, pg...) to interact with Database.

### Options

#### Source Database Related-Options
- `-a` ~ `--source-adapter` - Source DB adapter (MySQL, Postgres)
- `-j` ~ `--source-host` - Source DB host
- `-p` ~ `--source-port` - Source DB port
- `-d` ~ `--source-database` - Source DB name
- `-u` ~ `--source-username` - Source DB username
- `-s` ~ `--source-password` - Source DB password

#### Destination Database Related-Options
- `-q` ~ `--destination-adapter` - Destination DB adapter (MySQL, Postgres)
- `-k` ~ `--destination-host` - Destination DB host
- `-o` ~ `--destination-port` - Destination DB port
- `-c` ~ `--destination-database` - Destination DB name
- `-i` ~ `--destination-username` - Destination DB username
- `-x` ~ `--destination-password` - Destination DB password

#### Other parameters
- `-f` ~ `--schema-file` - Schema file (JSON) - **Not Required**
- `-t` ~ `--source-table-name` - Source table name
- `-r` ~ `--destination-table-name` - Destination table name

### Sample JSON Schema File

``` json
{
  "from_ds": "50-mysql",
  "from_table_name": "events",
  "dest_ds": "48-redshift",
  "dest_table_name": "public.pageviews",
  "columns": [
    {
      "column_name": "ts",
      "data_type": "bigint"
    },
    {
      "column_name": "page",
      "data_type": "varchar(15)",
    },
    {
      "column_name": "user_id",
      "data_type": "int",
    }
  ],
  "indexes": [
    { "columns": ["date_d"] },
    { "columns": ["page", "user_id"] }
  ]
}
```

### Execute

**Source DB is MySQL and Destination DB is Postgres**

```
ruby ./shining_sql.rb -a mysql -j localhost -p 3306 -d db1 -u user1 -s password1 -q postgres -k localhost -o 5432 -c db2 -i user2 -x password2 -t table1 -r table2
```

**Source DB is Postgres and Destination DB is MySQL**

```
ruby ./shining_sql.rb -a postgres -j localhost -p 5432 -d db1 -u user1 -s password1 -q mysql -k localhost -o 3306 -c db2 -i user2 -x password2 -t table1 -r table2
```

### To do list

- ~~Build Options Parser to read parameters from command line.~~
- ~~Using Sequel to connect to source db and destination db.~~
- ~~Using Sequel to read schema from source table.~~
- ~~Mapping data type from MySQL to Postgres and vice versa.~~ (Need Improve)
- Using Sequel to read indexes from source table.
- Using Sequel to read schema from JSON file.
- Using Sequel to create table in Destination db.
- Execute query to export data from source table to CSV file.
- Import data to destination table from CSV file.
- Write what's happening to history log.
- Improving Data Mapping between MySQL/Postgres.
  - Based on many scripts & documents such as:
    - https://github.com/AnatolyUss/FromMySqlToPostgreSql
    - https://dev.mysql.com/doc/workbench/en/wb-migration-database-postgresql-typemapping.html)
