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

      def metadata
        meta_path = config.hook_path(@name).join('meta.yml')
        Metadata.from_yaml(meta_path)
      end

      def fetch
        # Already local, nothing to do
      end

      private

      def config
        @config ||= Config
      end
    end
  end
end
