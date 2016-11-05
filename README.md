### Description

Pure ruby script to sync data from Production Database (MySQL, Postgres) to Reporting Database (MySQL, Postgres)

Using **Sequel** (and its dependencies like ruby-mysql, pg...) to interact with Database.

### Options

#### Source Database Related-Options
- `-a` ~ `--source-adapter` - Source DB Adapter (MySQL, Postgres)
- `-j` ~ `--source-host` - Source DB Host
- `-p` ~ `--source-port` - Source DB Port
- `-d` ~ `--source-database` - Source DB name
- `-u` ~ `--source-username` - Source DB Username
- `-s` ~ `--source-password` - Source DB Password

#### Destination Database Related-Options
- `-q` ~ `--destination-adapter` - Destination DB Adapter (MySQL, Postgres)
- `-k` ~ `--destination-host` - Destination DB Host
- `-o` ~ `--destination-port` - Destination DB Port
- `-c` ~ `--destination-database` - Destination DB name
- `-i` ~ `--destination-username` - Destination DB Username
- `-x` ~ `--destination-password` - Destination DB Password

#### Other parameters
- `-f` ~ `--schema-file` - Schema File (JSON) - **Not Required**
- `-t` ~ `--table-name` - Table name
- `-e` ~ `--source-prefix` - Source DB Schema Prefix (If Source DB is Postgres) - **Not Required** - Default is *public*
- `-r` ~ `--destination-prefix` - Destination DB Schema Prefix (If Destination DB is Postgres) - **Not Required** - Default is *dest*

### Sample JSON Schema File

```
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

### To do list

- ~~Build Options Parser to read parameters from command line.~~
- ~~Using Sequel to connect to source db and destination db.~~
- ~~Using Sequel to read schema from source table.~~
- Mapping data type from MySQL to Postgres and vice versa.
- Using Sequel to read indexes from source Table.
- Using Sequel to read schema from JSON File.
- Using Sequel to create table in Destination db.
- Execute query to export data from source table to CSV file.
- Import data to destination table from CSV file.
- Write what's happening to history log.
