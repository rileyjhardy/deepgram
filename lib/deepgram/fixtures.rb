# lib/your_gem/fixtures.rb
require 'pathname'

module Deepgram
  module Fixtures
    def self.root
      @root ||= Pathname.new(__dir__).join('..', '..', 'spec', 'fixtures')
    end

    def self.load_file(file_name)
      file_path = root.join(file_name)
      File.read(file_path)
    end

    def self.load_json(file_name)
      JSON.parse(load_file(file_name))
    end

    def self.load_yaml(file_name)
      YAML.safe_load(load_file(file_name), permitted_classes: [])
    end
  end
end
