require 'json'
Dir["./lib/**/*.rb"].each { |file| require file }

OUTPUT_SCHEMAS_FOLDER = "./output/schemas/"
# Print All Arguments
# ARGV.each do |arg|
#   puts "Argument: #{arg}"
# end

=begin
 ruby ./shining_sql.rb
 -t customers
 -a postgres -j localhost -p 5432 -d ut1022 -u viphat
 -q postgres -k localhost -o 5432 -c utalents -i viphat
=end

timestamp = Time.now.strftime("%Y%m%d%H%M")

options = Helpers::ReadOptions.parse!
puts options.inspect

src_connection_string = Helpers::ShiningSql.build_connection_string(
  options.source_adapter, options.source_host, options.source_port,
  options.source_database, options.source_username, options.source_password
)
puts src_connection_string

SRC_DB = Database::Connection.connect!(src_connection_string)
puts SRC_DB.test_connection

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

output_json_hash = Database::ReadTableSchema.read!(SRC_DB, options.source_table_name, output_json_hash)

File.open("#{OUTPUT_SCHEMAS_FOLDER}/#{options.source_table_name}-#{timestamp}.json", "w") do |f|
  f.write(JSON.pretty_generate(output_json_hash))
end

# des_connection_string = Helpers::ShiningSql.build_connection_string(
#   options.destination_adapter, options.destination_host, options.destination_port,
#   options.destination_database, options.destination_username, options.destination_password
# )
# puts des_connection_string
#
# DES_DB = Database::Connection.connect!(des_connection_string)
# puts DES_DB.test_connection
