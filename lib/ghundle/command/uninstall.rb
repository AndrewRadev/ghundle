require 'ghundle/command'

module Ghundle
  module Command
    # Uninstalls the given hook from the local repository.
    #
    class Uninstall < Common
      def call
        hook_name       = args.first
        hook_invocation = "ghundle run #{hook_name} $*\n"

        containing_hooks = Dir['.git/hooks/*'].map do |filename|
          contents = IO.read(filename)
          [filename, contents] if contents.include? hook_invocation
        end.compact

        if containing_hooks.empty?
          say "Hook #{hook_name} not installed"
        end

        containing_hooks.each do |filename, contents|
          say "Deleting from hook file `#{filename}`..."
          contents.gsub!(hook_invocation, '')
          File.open(filename, 'w') { |f| f.write(contents) }
        end
      end
    end
  end
end
