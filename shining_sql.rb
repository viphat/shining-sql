require 'json'
Dir["./lib/**/*.rb"].each { |file| require file }

OUTPUT_SCHEMAS_FOLDER = "./output/schemas/"

timestamp = Time.now.strftime("%Y%m%d%H%M")

options = Helpers::ReadOptions.parse!
puts options.inspect

src_connection_string = Helpers::ShiningSql.build_connection_string(
  options.source_adapter, options.source_host, options.source_port,
  options.source_database, options.source_username, options.source_password
)

src_db = Database::Connection.connect!(src_connection_string)
exit unless src_db.test_connection

des_connection_string = Helpers::ShiningSql.build_connection_string(
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
puts JSON.pretty_generate(schema_hash)

Database::CreateTable.create_table(des_db, options, schema_hash)
