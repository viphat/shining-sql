require 'pry'

module Database
  module ReadTableSchema

    MYSQL_TO_POSTGRES_DATA_TYPES_MAPPING = {
      "tinyint": "smallint",
      "smallint": "smallint",
      "mediumint": "integer",
      "bigint": "bigint",

      "tinyint unsigned": "smallint",
      "smallint unsigned": "smallint",
      "mediumint unsigned": "integer",
      "int unsigned": "integer",
      "bigint unsigned": "bigint",

      "float": "real",
      "float unsigned": "real",
      "double": "double precision",

      "boolean": "boolean",

      "tinytext": "text",
      "text": "text",
      "mediumtext": "text",
      "longtext": "text",
      "char": "char",
      "varchar": "varchar",

      "binary": "bytea",
      "varbinary": "bytea",
      "tinyblob": "bytea",
      "blob": "bytea",
      "mediumblob": "bytea",
      "longblob": "bytea",

      "date": "date",
      "time": "time without time zone",
      "datetime": "timestamp without time zone",
      "timestamp": "timestamp without time zone"
    }

    POSTGRES_TO_MYSQL_DATA_TYPES_MAPPING = {
      "smallint": "smallint",
      "integer": "mediumint",
      "bigint": "bigint",

      "real": "float",

      "double precision": "double",
      "numeric": "decimal",
      "decimal": "decimal",
      "money": "decimal",

      "boolean": "boolean",

      "text": "text",
      "char": "char",
      "varchar": "varchar",

      "bytea": "blob",

      "date": "date",
      "time": "time",
      "time without time zone": "time",
      "timestamp": "datetime",
      "timestamp without time zone": "datetime",
      "interval": "time"
    }

    def self.read_columns(db, options, json_hash)
      columns = []
      db.schema(options.source_table_name).each do |column|
        columns.push({
          "column_name": column[0].to_s,
          "data_type": Database::ReadTableSchema.data_type_mapping(options, column[1][:db_type].to_s)
        })
      end
      json_hash.merge(
        "columns": columns
      )
    end

    def self.data_type_mapping(options, data_type)
      return data_type if options.source_adapter == options.destination_adapter
      if options.source_adapter == 'mysql' && options.destination_adapter == 'postgres'
        dkey = data_type
        Database::ReadTableSchema::MYSQL_TO_POSTGRES_DATA_TYPES_MAPPING.keys.each do |key|
          dkey = key if data_type.downcase.start_with?(key.to_s)
        end
        Database::ReadTableSchema::MYSQL_TO_POSTGRES_DATA_TYPES_MAPPING[dkey.to_sym]
      else
        Database::ReadTableSchema::POSTGRES_TO_MYSQL_DATA_TYPES_MAPPING[data_type.downcase.to_sym]
      end
    end

    def self.get_mysql_table_indexes(table_name)
      # TODO
    end

    def self.get_postgres_table_indexes(table_name)
      """
        SELECT
          t.relname AS table_name,
          i.relname AS index_name,
          array_to_string(array_agg(a.attname), ', ') AS column_names
        FROM
          pg_class t, pg_class i, pg_index ix, pg_attribute a
        WHERE
          t.oid = ix.indrelid
          and i.oid = ix.indexrelid
          and a.attrelid = t.oid
          and a.attnum = ANY(ix.indkey)
          and t.relkind = 'r'
          and t.relname = '#{table_name}'
        GROUP BY
          t.relname,
          i.relname
        ORDER BY
          t.relname,
          i.relname;
      """
    end
  end
end
