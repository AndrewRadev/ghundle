require 'net/http'
require 'ghundle/metadata'
require 'ghundle/source/common'

module Ghundle
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
    class Github < Common
      attr_reader :username, :repo, :path
      attr_reader :script_name

      def initialize(description)
        @description            = description
        @username, @repo, @path = parse_description(@description)
        @path                   = Pathname.new(@path)
        @script_name            = path.basename
      end

      def hook_name
        path.basename
      end

      def metadata
        @metadata ||=
          begin
            url          = raw_github_url(@path.join('meta.yml'))
            status, yaml = http_get(url)

            if status != 200
              raise AppError.new("Couldn't fetch metadata file from #{url}, got response status: #{status}")
            end

            Metadata.new(YAML.load(yaml))
          end
      end

      def fetch(destination_path)
        destination_path = Pathname.new(destination_path)

        local_source = Local.new(destination_path)
        return local_source if local_source.exists?

        FileUtils.mkdir_p(destination_path)

        status, script = http_get(raw_github_url(@path.join('run')))
        if status != 200
          raise AppError.new("Couldn't fetch script file from #{url}, got response status: #{status}")
        end

        destination_path.join('run').open('w') do |f|
          f.write(script)
        end

        destination_path.join('meta.yml').open('w') do |f|
          f.write(YAML.dump(metadata.to_h))
        end

        File.chmod(0755, destination_path.join('run'))

        local_source
      end

      def to_s
        @path
      end

      private

      def http_get(url_string)
        uri      = URI(url_string)
        response = Net::HTTP.get_response(uri)

        [response.code.to_i, response.body]
      end

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
