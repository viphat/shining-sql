module Database
  module DataTypeMapping
    #TODO - Need improve Data Mapping Method
    MYSQL_TO_POSTGRES_DATA_TYPES_MAPPING = {
      "tinyint": "smallint",
      "smallint": "smallint",
      "mediumint": "integer",
      "bigint": "bigint",
      "int": "integer",

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
      "character varying": "varchar",

      "bytea": "blob",

      "date": "date",
      "time": "time",
      "time without time zone": "time",
      "timestamp": "datetime",
      "timestamp without time zone": "datetime",
      "interval": "time"
    }

    def self.data_type_mapping(options, data_type)
      return data_type if options.source_adapter == options.destination_adapter
      if options.source_adapter == 'mysql' && options.destination_adapter == 'postgres'
        dkey = data_type
        MYSQL_TO_POSTGRES_DATA_TYPES_MAPPING.keys.each do |key|
          dkey = key if data_type.downcase.start_with?(key.to_s)
        end
        MYSQL_TO_POSTGRES_DATA_TYPES_MAPPING[dkey.to_sym]
      else
        POSTGRES_TO_MYSQL_DATA_TYPES_MAPPING[data_type.downcase.to_sym]
      end
    end



  end
end
