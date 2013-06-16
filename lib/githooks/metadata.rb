require 'githooks/config'

module Githooks
  class Metadata
    attr_reader :type, :version, :description

    def self.from_yaml(filename)
      new(YAML.load_file(filename))
    end

    def initialize(data = {})
      @type        = data['type']
      @version     = data['version']
      @description = data['description']
    end

    private

    def config
      @config ||= Config
    end
  end
end
