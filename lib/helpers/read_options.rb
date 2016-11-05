require 'optparse'
require 'ostruct'

module Helpers
  module ReadOptions
    def self.parse!
      options = OpenStruct.new()
      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: shining_sql.rb [options]"

        # SOURCE DB
        opts.on("-a", "--source-adapter SOURCE_ADAPTER", "Your Source Database Adapter", "mysql, postgres") do |value|
          unless ['mysql','postgres'].include?(value)
            puts 'Only Mysql or Postgres is accepted for destination Adapter'
            exit
          end
          options.source_adapter = value
        end

        opts.on("-j", "--source-host SOURCE_HOST", "Your Source Database Host", "Ex: localhost OR IP v4 Address") do |value|
          options.source_host = value
        end

        opts.on("-p", "--source-port SOURCE_PORT", "Your Source Database Port", "Ex: 5432") do |value|
          options.source_port = value
        end

        opts.on("-d", "--source-database SOURCE_DATABASE", "Your Source Database Name", "Ex: mydatabase") do |value|
          options.source_database = value
        end

        opts.on("-u", "--source-username SOURCE_USERNAME", "Your Source Database Username", "Ex: myusername") do |value|
          options.source_username = value
        end

        opts.on("-s", "--source-password SOURCE_PASSWORD", "Your Source Database Password", "Ex: mypassword") do |value|
          options.source_password = value
        end

        # DESTINATION DB
        opts.on("-q", "--destination-adapter DESTINATION_ADAPTER", "Your Destination Database Adapter", "mysql, postgres") do |value|
          unless ['mysql','postgres'].include?(value)
            puts 'Only Mysql or Postgres is accepted for Destination Adapter'
            exit
          end
          options.destination_adapter = value
        end

        opts.on("-k", "--destination-host DESTINATION_HOST", "Your Destination Database Host", "Ex: localhost OR IP v4 Address") do |value|
          options.destination_host = value
        end

        opts.on("-o", "--destination-port DESTINATION_PORT", "Your Destination Database Port", "Ex: 5432") do |value|
          options.destination_port = value
        end

        opts.on("-c", "--destination-database DESTINATION_DATABASE", "Your Destination Database Name", "Ex: mydatabase") do |value|
          options.destination_database = value
        end

        opts.on("-i", "--destination-username DESTINATION_USERNAME", "Your Destination Database Username", "Ex: myusername") do |value|
          options.destination_username = value
        end

        opts.on("-x", "--destination-password DESTINATION_PASSWORD", "Your Destination Database Password", "Ex: mypassword") do |value|
          options.destination_password = value
        end

        # Other Parameters
        opts.on("-t", "--source-table-name SOURCE_TABLE_NAME", "Your Source Table Name", "Ex: table1") do |value|
          options.source_table_name = value
        end

        opts.on("-r", "--destination-table-name DESTINATION_TABLE_NAME", "Destination Table Name", "Ex: public.table1") do |value|
          options.destination_table_name = value
        end

        opts.on("-f", "--schema-file SCHEMA_FILE", "Your Schema File", "Ex: /path/to/table1-schema.json") do |value|
          options.schema_file = value
        end

        # Help
        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end

      end
      opt_parser.parse!
      return options
    end
  end
end
