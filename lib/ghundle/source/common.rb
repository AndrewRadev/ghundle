module Ghundle
  module Source
    # A descendant of Source::Common is a source that can be used to fetch a
    # hook from a remote location into a local path. Look at the various
    # children of this class to understand its usage better.
    #
    class Common
      # Gets the name of the hook based on the url/path it's given
      def hook_name
        raise NotImplementedError
      end

      # Returns this source's metadata object.
      def metadata
        raise NotImplementedError
      end

      # Fetches the source into the local path, making it ready for execution.
      # Returns a Source::Local that can be used to access its data.
      def fetch(destination_path)
        raise NotImplementedError
      end

      # Checks if the source was already extracted to the given path.
      def fetched?(destination_path)
        raise NotImplementedError
      end
    end
  end
end
