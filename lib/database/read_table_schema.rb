require 'pry'

module Database
  module ReadTableSchema
    def self.read!(db, table_name, json_hash)
      unless db.table_exists?(table_name)
        puts 'Table doesn\'t exist.'
        exit
      end
      columns = []
      db.schema(table_name).each do |column|
        columns.push({
          "column_name": column[0].to_s,
          "data_type": column[1][:db_type].to_s
        })
      end
      json_hash.merge(
        "columns": columns
      )
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
