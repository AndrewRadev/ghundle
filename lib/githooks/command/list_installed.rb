require 'githooks/command'

module Githooks
  module Command
    # Lists all hooks installed in the current repo.
    #
    class ListInstalled < Common
      def call
        puts
        puts output
        puts
      end

      def output
        hook_names = []

        Dir['.git/hooks/*'].each do |filename|
          File.open(filename) do |f|
            f.each_line do |line|
              if line =~ /^githooks run (.*) \$\*/
                hook_names << $1.strip
              end
            end
          end
        end

        hook_names.map do |hook_name|
          source = Source::Local.new(config.hook_path(hook_name))

          if source.exists?
            hook_description(Hook.new(source))
          else
            "Warning: Hook `#{hook_name}` does not exist".foreground(:red)
          end
        end.join("\n")
      end
    end
  end
end
