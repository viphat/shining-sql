require 'fileutils'
require 'pry'

module Database
  module ExportData

    def self.export!(db, options, output_file, schema_hash)
      columns = self.get_columns(options, schema_hash)
      if options.source_adapter == 'mysql'
        # export output file to /tmp then copy it to output_folder
        tmp_output_file = "/tmp/#{File.basename(output_file)}"
        db.run(self.get_mysql_query_string(options.source_table_name, columns, tmp_output_file))
        return FileUtils.cp(tmp_output_file, output_file)
      end
      db.run(self.get_postgres_query_string(options.source_table_name, columns, output_file))
    end

    def self.get_columns(options, schema_hash)
      output = []
      schema_hash["columns"].each do |column|
        output.push(
          if options.source_adapter == 'mysql'
            # "IFNULL(#{column['column_name']}, '\\N')"
            column['column_name']
          else
            column['column_name']
          end
        )
      end
      output.join(", ")
    end

    def self.get_mysql_query_string(table_name, columns, tmp_output_file)
      # For MySQL, Disable secure_file_priv before trying to export data into files
      """
        SELECT #{columns} FROM #{table_name}
        INTO OUTFILE '#{tmp_output_file}'
        FIELDS ENCLOSED BY '\"'
        TERMINATED BY ','
        LINES TERMINATED BY '\r\n';
      """
    end

    def self.get_postgres_query_string(table_name, columns, output_file)
      """
        COPY (SELECT #{columns} FROM #{table_name}) TO '#{output_file}' WITH(NULL '\\N', DELIMITER ',', FORCE_QUOTE *, FORMAT CSV);
      """
    end

  end
end
