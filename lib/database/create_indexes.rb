module Database
  module CreateIndexes

    def self.create_indexes!(db, options, schema_hash)
      schema_hash['indexes'].each do |index|
        db.run(self.create_index_query(options.destination_table_name, index))
      end
    end

    def self.create_index_query(table_name, index)
      index_name = "index_#{table_name}_#{index["columns"].join("_")}"
      "CREATE INDEX #{index_name} on #{table_name}(#{index['columns'].join(',')})"
    end

  end
end
