require 'pathname'
require 'githooks/metadata'
require 'githooks/source/common'

module Githooks
  module Source
    # Represents the local source of a hook. This means that the hook has
    # already been fetched to a local directory where it can easily be
    # installed in a repository.
    #
    class Local < Common
      def initialize(local_path)
        @local_path = Pathname.new(local_path)
      end

      def name
        @name ||= File.basename(@local_path)
      end

      def validate
        return if exists?

        if not script_path.file?
          raise AppError.new("Script not found: #{script_path}")
        end

        if not script_path.executable?
          raise AppError.new("Script not executable: #{script_path}")
        end

        if not metadata_path.file?
          raise AppError.new("Metadata file not found: #{metadata_path}")
        end
      end

      def exists?
        script_path.executable? and metadata_path.file?
      end

      def metadata
        validate
        Metadata.from_yaml(metadata_path)
      end

      def fetch
        self
      end

      private

      def script_path
        @local_path.join('run')
      end

      def metadata_path
        @local_path.join('meta.yml')
      end
    end
  end
end
