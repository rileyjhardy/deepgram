# frozen_string_literal: true

require 'pathname'

module Deepgram
  # The Fixtures module provides utility methods for loading fixture files
  # used for testing purposes.
  module Fixtures
    # Returns the root directory path where the fixture files are located.
    #
    # @return [Pathname] The root directory path.
    def self.root
      @root ||= Pathname.new(__dir__).join('..', '..', 'spec', 'fixtures')
    end

    # Loads the content of a fixture file as a string.
    #
    # @param file_name [String] The name of the fixture file to load.
    #
    # @return [String] The content of the loaded file.
    def self.load_file(file_name)
      file_path = root.join(file_name)
      File.read(file_path)
    end

    # Loads the content of a JSON fixture file and parses it as a Ruby object.
    #
    # @param file_name [String] The name of the JSON fixture file to load.
    #
    # @return [Object] The parsed Ruby object from the JSON file.
    def self.load_json(file_name)
      JSON.parse(load_file(file_name))
    end

    # Loads the content of a YAML fixture file and parses it as a Ruby object.
    #
    # @param file_name [String] The name of the YAML fixture file to load.
    #
    # @return [Object] The parsed Ruby object from the YAML file.
    def self.load_yaml(file_name)
      YAML.safe_load(load_file(file_name), permitted_classes: [])
    end
  end
end
