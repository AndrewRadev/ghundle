require 'githooks/config'
require 'githooks/source/local'
require 'open-uri'

module Githooks
  class Hook
    attr_reader :name, :source

    def initialize(name, source = nil)
      @name = name
      @source ||= Source.local(name)
    end

    def type
      metadata.type
    end

    def metadata
      @metadata ||= source.metadata
    end

    def source

    end

    def run(*args)
      validate
      system(script_path, *args)
    end

    def validate
      if not name
        error "No hook name given"
      end

      script_path = config.hook_path(hook_name)

      if not File.exist?(script_path)
        error "The file `#{script_path}` doesn't exist"
      end

      if not File.executable?(script_path)
        error "The file `#{script_path}` is not executable"
      end
    end

    def fetch
      return if local?

      destination = config.hook_path("#{metadata.type}/#{name}")
      source.fetch(destination)
    end

    def local?
      File.executable?(config.hook_path("#{type}/#{name}"))
    end

    private

    def error(*args)
      raise AppError.new(*args)
    end

    def config
      @config ||= Config
    end
  end
end
