require 'githooks/config'

module Githooks
  class Hook
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def name
      source.name
    end

    def metadata
      source.metadata
    end

    def run(*args)
      source.validate
      system source.script_path.to_s, *args
    end
  end
end
