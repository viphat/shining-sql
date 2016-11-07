module Database
  module ReadTableSchema

    def self.read_from_db(db, options, json_hash)

      # read_columns
      columns = []
      db.schema(options.source_table_name).each do |column|
        columns.push({
          "column_name": column[0].to_s,
          "data_type": Database::DataTypeMapping.data_type_mapping(options, column[1][:db_type].to_s)
        })
      end
      json_hash.merge!(
        "columns": columns
      )
      # read_indexes
      indexes = Database::ReadIndexes.read(db, options)
      json_hash.merge(
        "indexes": indexes
      )
    end

  end
end
