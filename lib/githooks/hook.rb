require 'githooks/config'
require 'githooks/metadata'

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
        source   = LocalSource.new(path)
        metadata = source.metadata

        new(name, metadata, source)
      end

      def from_remote_source(url)
        # validate
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

    # TODO (2013-05-20) Validation
    class LocalSource
      attr_reader :path

      def initialize(path)
        @path = Pathname.new(path)
      end

      def metadata
        @metadata ||= Metadata.new(YAML.load_file("#{@path}/meta.yml"))
      end

      def fetch(destination_path)
        FileUtils.mkdir_p(File.dirname(destination_path))
        FileUtils.cp "#{@path}/run", destination_path
      end

      def to_s
        @path
      end
    end

    def config
      @config ||= Config
    end
  end
end
