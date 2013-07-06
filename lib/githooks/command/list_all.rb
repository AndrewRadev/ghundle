require 'githooks/command'

module Githooks
  module Command
    # Lists all available hooks stored in the hook home directory.
    #
    class ListAll < Common
      def call
        puts
        puts output
        puts
      end

      def output
        Dir[config.hooks_root.join('*')].map do |path|
          next if not File.directory?(path)

          hook = Hook.new(Source::Local.new(path))
          hook_description(hook)
        end.join("\n")
      end
    end
  end
end
