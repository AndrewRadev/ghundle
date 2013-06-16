module Githooks
  module Source
    class Common
      def metadata
        raise NotImplementedError
      end

      def fetch
        raise NotImplementedError
      end
    end
  end
end
