require 'githooks/hook_version'

module Githooks
  class Metadata
    attr_reader :types, :version, :description

    def self.from_yaml(filename)
      new(YAML.load_file(filename))
    end

    def initialize(data = {})
      @version     = HookVersion.new(data['version'])
      @types       = data['types']
      @description = data['description']
    end

    def to_h
      {
        'types'       => types,
        'version'     => version,
        'description' => description,
      }
    end
  end
end
