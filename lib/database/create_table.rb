module Database
  module CreateTable

    def self.create_table(db, options, schema_hash)
      # Drop Table in Destination DB if exists
      begin
        query = Database::CreateTable.drop_table_if_exists(options.destination_table_name)
        query += """
          #{Database::CreateTable.generate_create_table_syntax(options.destination_table_name, schema_hash)}
        """
        db.run(query)
      rescue Exception => ex
        puts ex
        puts 'Has error in create table'
        exit
      end
    end

    def self.drop_table_if_exists(table_name)
      "DROP TABLE IF EXISTS #{table_name};"
    end

    def self.generate_create_table_syntax(table_name, schema_hash)
      query = "CREATE TABLE #{table_name}("
      cols = []

      schema_hash["columns"].each do |col|
        cols.push("#{col['column_name']} #{col['data_type']}")
      end
      query += cols.join(", ")
      query += ");"
    end

    def self.check_table_exists_in_mysql(table_name)
      """
        SHOW TABLES LIKE #{table_name};
      """
    end

    def self.check_table_exists_in_postgres(table_name)
      """
        SELECT 1
        FROM pg_catalog.pg_class c
        JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
        WHERE
          n.nspname = ANY(current_schemas(FALSE))
          AND n.nspname NOT LIKE 'pg_%'
          AND c.relname = '#{table_name}'
          AND c.relkind = 'r'
      """
    end

  end
end
