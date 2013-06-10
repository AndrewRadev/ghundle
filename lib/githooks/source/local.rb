module Githooks
  module Source
    class Local
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
  end
end
