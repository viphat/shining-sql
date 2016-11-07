module Database
  module ReadIndexes

    def self.read(db, options)
      if (options.source_adapter == 'mysql')
        Database::ReadIndexes.read_from_mysql(db, options)
      else
        Database::ReadIndexes.read_from_postgres(db, options)
      end
    end

    def self.read_from_mysql(db, options)
      indexes = []
      previous_key = nil
      columns = []
      index = 0
      db.fetch(Database::ReadIndexes.get_mysql_table_indexes(options.source_table_name)).each do |row|
        index += 1
        if previous_key == nil || previous_key == row[:Key_name]
          columns.push(row[:Column_name])
        elsif columns.length >= 1 && index > 0
          indexes.push({
            "columns": columns
          })
          columns = [row[:Column_name]]
        end
        previous_key = row[:Key_name]
      end
      if (columns.length > 0)
        indexes.push({
          "columns": columns
          })
      end
      indexes
    end

    def self.read_from_postgres(db, options)
      indexes = []
      db.fetch(Database::ReadIndexes.get_postgres_table_indexes(options.source_table_name)).each do |row|
        indexes.push({
          "columns": row[:column_names].split(", ")
        })
      end
      indexes
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

    def self.get_mysql_table_indexes(table_name)
      """
        SHOW INDEX FROM #{table_name};
      """
    end

  end
end
