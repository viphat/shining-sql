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
puts src_connection_string

src_db = Database::Connection.connect!(src_connection_string)
puts src_db.test_connection

des_connection_string = Helpers::ShiningSql.build_connection_string(
  options.destination_adapter, options.destination_host, options.destination_port,
  options.destination_database, options.destination_username, options.destination_password
)

puts des_connection_string

output_json_hash = {
  "from_ds": src_connection_string,
  "from_table_name": options.source_table_name,
  "des_ds": des_connection_string,
  "des_table_name": options.destination_table_name
}

check_table_exists = Proc.new do |table_name|
  unless src_db.table_exists?(table_name)
    puts 'Table doesn\'t exist.'
    exit
  end
end

check_table_exists.call(options.source_table_name)

output_json_hash = Database::ReadTableSchema.read_from_db(src_db, options, output_json_hash)

File.open("#{OUTPUT_SCHEMAS_FOLDER}/#{options.source_table_name}-#{timestamp}.json", "w") do |f|
  f.write(JSON.pretty_generate(output_json_hash))
end

# des_db = Database::Connection.connect!(des_connection_string)
# puts des_db.test_connection
