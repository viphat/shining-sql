module Database
  module ImportData

    def self.import!(db, options, file)
      if options.destination_adapter == 'mysql'
        query = self.import_mysql_query(options.destination_table_name, file)
      else
        query = self.import_postgres_query(options.destination_table_name, file)
      end
      db.run(query)
    end

    def self.import_mysql_query(table_name, file)
      """
        LOAD DATA INFILE '#{file}'
        INTO TABLE #{table_name}
        FIELDS TERMINATED BY ','
        ENCLOSED BY '\"'
        LINES TERMINATED BY '\n';
      """
    end

    def self.import_postgres_query(table_name, file)
      """
        COPY #{table_name} FROM '#{file}' WITH(NULL '\\N', DELIMITER ',', FORMAT CSV);
      """
    end

  end
end
