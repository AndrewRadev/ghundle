module Githooks
  class Metadata
    attr_reader :types, :version, :description

    def self.from_yaml(filename)
      new(YAML.load_file(filename))
    end

    def initialize(data = {})
      @types       = data['types']
      @version     = data['version']
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
