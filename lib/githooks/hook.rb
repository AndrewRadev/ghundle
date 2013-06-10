require 'githooks/config'
require 'githooks/metadata'
require 'githooks/source'
require 'open-uri'

module Githooks
  class Hook
    attr_reader :name, :metadata, :source

    def initialize(name, metadata, source = nil)
      @name     = name
      @metadata = metadata
      @source   = source
    end

    def type
      metadata.type
    end

    class << self
      def from_local_source(path)
        name     = File.basename(path)
        source   = Source::Local.new(path)
        metadata = source.metadata

        new(name, metadata, source)
      end

      # <username>/<repo>:<path>
      def from_github_source(description)
        source   = Source::Github.new(description)
        name     = source.script_name
        metadata = source.metadata

        new(name, metadata, source)
      end

      def from_cached_script(hook_name)
        # validate
      end
    end

    def fetch
      return if cached?

      destination = config.hook_path("#{metadata.type}/#{name}")
      # say "Copying hook to #{destination_path}..."
      source.fetch(destination)
    end

    def cached?
      File.executable?(config.hook_path("#{type}/#{name}"))
    end

    private

    def config
      @config ||= Config
    end
  end
end
