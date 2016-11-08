require 'json'

module Helpers
  module ReadJson

    def self.read_json_file(file)
      exit if file.nil? || !File.exist?(file)
      file = File.read(file)
      JSON.parse(file)
    end

  end
end
