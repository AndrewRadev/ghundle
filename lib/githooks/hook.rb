require 'githooks/config'
require 'githooks/metadata'
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
        source   = LocalSource.new(path)
        metadata = source.metadata

        new(name, metadata, source)
      end

      # <username>/<repo>:<path>
      def from_github_source(description)
        source   = GithubSource.new(description)
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

    class GithubSource
      attr_reader :username, :repo, :path
      attr_reader :script_name

      def initialize(description)
        @description               = description
        project_description, @path = @description.split(':')
        @username, @repo           = project_description.split('/')
        @script_name               = File.basename(path)
      end

      def metadata
        @metadata ||=
          begin
            url  = raw_github_url("#{@path}/meta.yml")
            yaml = open(url).read
            Metadata.new(YAML.load(yaml))
          end
      end

      def fetch(destination_path)
        FileUtils.mkdir_p(File.dirname(destination_path))

        File.open(destination_path, 'w') do |f|
          script = open(raw_github_url("#{@path}/run")).read
          f.write(script)
        end

        File.chmod(0755, destination_path)
      end

      def to_s
        @path
      end

      private

      def raw_github_url(path)
        "https://raw.github.com/#{@username}/#{@repo}/master/#{path}"
      end
    end

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
