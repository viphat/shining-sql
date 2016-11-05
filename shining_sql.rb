Dir["./lib/**/*.rb"].each { |file| require file }

# Print All Arguments
# ARGV.each do |arg|
#   puts "Argument: #{arg}"
# end

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

DES_DB = Database::Connection.connect!(des_connection_string)
puts DES_DB.test_connection
