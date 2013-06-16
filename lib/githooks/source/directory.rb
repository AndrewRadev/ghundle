require 'githooks/metadata'
require 'githooks/source/common'

module Githooks
  module Source
    # Represents a directory on the filesystem that has a hook-compatible
    # directory structure. It needs to be fetched to the local hook root in
    # order to use the hook.
    #
    class Directory
      attr_reader :path

      def initialize(path)
        @source_path = Pathname.new(path)
      end

      def metadata
        @metadata ||= Metadata.new(YAML.load_file(@source_path.join("meta.yml")))
      end

      def fetch(destination_path)
        destination_path = Pathname.new(destination_path)

        FileUtils.mkdir_p(destination_path)
        FileUtils.cp @source_path.join("meta.yml"), destination_path.join("meta.yml")
        FileUtils.cp @source_path.join("run"), destination_path.join("run")
      end

      def to_s
        @path
      end
    end
  end
end
