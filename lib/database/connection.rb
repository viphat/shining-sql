require 'sequel'
require 'logger'

module Database
  module Connection
    DB_LOGGER = 'logs/db.log'
    def self.connect!(connection_string)
      Sequel.connect(connection_string, logger: Logger.new(Database::Connection::DB_LOGGER))
    end

  end
end
