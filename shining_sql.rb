require 'json'
Dir["./lib/**/*.rb"].each { |file| require file }

=begin
ruby ./shining_sql.rb -a mysql -j localhost -p 3306 -d grokking -u root -s 123456 -q postgres -k localhost -o 5432 -c viphat -i viphat -t user -r user
ruby ./shining_sql.rb -a postgres -j localhost -p 5432 -d ut1022 -u viphat -q mysql -k localhost -o 3306 -c utalents -i root -x 123456 -t franchisees -r franchisees345 -f ./tmp/franchisee.json
=end

OUTPUT_SCHEMAS_FOLDER = "#{Dir.pwd}/output/schemas"
OUTPUT_DATA_FOLDER = "#{Dir.pwd}/output/data"

timestamp = Time.now.strftime("%Y%m%d%H%M%S")

options = Helpers::ReadOptions.parse!

src_connection_string = Helpers::Common.build_connection_string(
  options.source_adapter, options.source_host, options.source_port,
  options.source_database, options.source_username, options.source_password
)

src_db = Database::Connection.connect!(src_connection_string)
exit unless src_db.test_connection

des_connection_string = Helpers::Common.build_connection_string(
  options.destination_adapter, options.destination_host, options.destination_port,
  options.destination_database, options.destination_username, options.destination_password
)

des_db = Database::Connection.connect!(des_connection_string)
exit unless des_db.test_connection

check_table_exists = Proc.new do |table_name|
  unless src_db.table_exists?(table_name)
    puts 'Table doesn\'t exist.'
    exit
  end
end

check_table_exists.call(options.source_table_name)

json_file = options.schema_file

if json_file.nil?
  # Create Json file by read schema from table.
  output_json_hash = {
    "from_ds": src_connection_string,
    "from_table_name": options.source_table_name,
    "des_ds": des_connection_string,
    "des_table_name": options.destination_table_name
  }

  output_json_hash = Database::ReadTableSchema.read_from_db(src_db, options, output_json_hash)
  json_file = "#{OUTPUT_SCHEMAS_FOLDER}/#{options.source_table_name}-#{timestamp}.json"
  File.open(json_file, "w") do |f|
    f.write(JSON.pretty_generate(output_json_hash))
  end
end

schema_hash = Helpers::ReadJson.read_json_file(json_file)

Database::CreateTable.create_table(des_db, options, schema_hash)

output_file = "#{OUTPUT_DATA_FOLDER}/#{options.source_table_name}-#{timestamp}.csv"
Database::ExportData.export!(src_db, options, output_file, schema_hash)
puts output_file
