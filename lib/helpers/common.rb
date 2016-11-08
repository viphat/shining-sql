module Helpers
  module Common

    def self.build_connection_string(adapter, host, port, db, username, password=nil)
      "#{adapter}://#{username}#{password.nil? ? '' : ':' + password}@#{host}:#{port}/#{db}"
    end

  end
end
