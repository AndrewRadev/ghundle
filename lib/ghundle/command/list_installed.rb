require 'set'
require 'ghundle/command'

module Ghundle
  module Command
    # Lists all hooks installed in the current repo.
    #
    class ListInstalled < Common
      def call
        puts output.strip
      end

      def output
        hook_names = Set.new

        Dir['.git/hooks/*'].each do |filename|
          File.open(filename) do |f|
            f.each_line do |line|
              if line =~ /^ghundle run (.*) \$\*/
                hook_names << $1.strip
              end
            end
          end
        end

        hook_names.sort.map do |hook_name|
          source = Source::Local.new(config.hook_path(hook_name))

          if source.exists?
            hook_description(Hook.new(source))
          else
            Rainbow("Warning: Hook `#{hook_name}` does not exist").red
          end
        end.join("\n")
      end
    end
  end
end
