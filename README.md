
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



```

### To do list

- Build Options Parser to read parameters from command line
- Using ActiveRecord without Rails to connect to Source DB and Destination DB
- Using ActiveRecord Migrations Without Rails to Read Schema from User (JSON File) or Read Schema from Source Table and Create Table in Destination DB (If needed)
- Cron job to execute script
