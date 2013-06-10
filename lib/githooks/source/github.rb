module Githooks
  module Source
    class Github
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
  end
end
