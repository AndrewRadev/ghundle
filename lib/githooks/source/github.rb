require 'open-uri'
require 'githooks/metadata'
require 'githooks/source/common'

module Githooks
  module Source
    # Represents a remote hook on github.com. The description is of the format:
    #
    #   github.com/<username>/<repo>/<path/to/hook>
    #
    # Example:
    #
    #   github.com/AndrewRadev/hooks/ctags
    #
    # It needs to be fetched to the local hook root in order to use the hook.
    #
    class Github
      attr_reader :username, :repo, :path
      attr_reader :script_name

      def initialize(description)
        @description            = description
        @username, @repo, @path = parse_description(@description)
        @path                   = Pathname.new(@path)
        @script_name            = path.basename
      end

      def metadata
        @metadata ||=
          begin
            url  = raw_github_url(@path.join('meta.yml'))
            yaml = open(url).read
            Metadata.new(YAML.load(yaml))
          end
      end

      def fetch(destination_path)
        destination_path = Pathname.new(destination_path)
        FileUtils.mkdir_p(destination_path)

        destination_path.join('run').open('w') do |f|
          script = open(raw_github_url(@path.join('run'))).read
          f.write(script)
        end

        destination_path.join('meta.yml').open('w') do |f|
          f.write(YAML.dump(metadata))
        end

        File.chmod(0755, destination_path.join('run'))
      end

      def to_s
        @path
      end

      private

      def parse_description(description)
        components = description.split('/')
        username   = components[1]
        repo       = components[2]
        path       = components[3..-1].join('/')

        [username, repo, path]
      end

      def raw_github_url(path)
        "https://raw.github.com/#{@username}/#{@repo}/master/#{path}"
      end
    end
  end
end
