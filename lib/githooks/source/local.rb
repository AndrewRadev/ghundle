require 'githooks/metadata'
require 'githooks/source/common'

module Githooks
  module Source
    # Represents the local source of a hook. This means that the hook has
    # already been fetched to a local directory where it can easily be
    # installed in a repository.
    #
    class Local < Common
      def initialize(name)
        @name = name
      end

      def validate
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

      def metadata
        validate
        Metadata.from_yaml(metadata_path)
      end

      def fetch
        # Already local, nothing to do
      end

      private

      def script_path
        config.hook_path(@name).join('run')
      end

      def metadata_path
        config.hook_path(@name).join('meta.yml')
      end

      def config
        @config ||= Config
      end
    end
  end
end
