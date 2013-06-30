require 'pathname'
require 'githooks/metadata'
require 'githooks/source/common'

module Githooks
  module Source
    # Represents a directory on the filesystem that has a hook-compatible
    # directory structure. It needs to be fetched to the local hook root in
    # order to use the hook.
    #
    class Directory < Common
      attr_reader :source_path

      def initialize(path)
        @source_path = Pathname.new(path)
      end

      def metadata
        @metadata ||=
          begin
            validate
            Metadata.new(YAML.load_file(source_path.join("meta.yml")))
          end
      end

      def fetch(destination_path)
        validate
        destination_path = Pathname.new(destination_path)

        local_source = Local.new(destination_path)
        return local_source if local_source.exists?

        FileUtils.mkdir_p(destination_path)
        FileUtils.cp source_path.join("meta.yml"), destination_path.join("meta.yml")
        FileUtils.cp source_path.join("run"), destination_path.join("run")

        local_source
      end

      def validate
        source_script_path   = source_path.join('run')
        source_metadata_path = source_path.join('meta.yml')

        if not source_script_path.file?
          raise AppError.new("Script not found: #{source_script_path}")
        end

        if not source_script_path.executable?
          raise AppError.new("Script not executable: #{source_script_path}")
        end

        if not source_metadata_path.file?
          raise AppError.new("Metadata file not found: #{metadata_source_path}")
        end
      end

      def to_s
        source_path
      end
    end
  end
end
