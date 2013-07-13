require 'yaml'
require 'githooks/command'
require 'githooks/source'
require 'githooks/hook'

module Githooks
  module Command
    # Tries to figure out what kind of a source the given identifier represents
    # and fetches the hook locally.
    #
    class Fetch < Common
      def call
        args.each do |identifier|
          if identifier =~ /^github.com/
            source = Source::Github.new(identifier)
          elsif File.directory?(identifier)
            source = Source::Directory.new(identifier)
          elsif File.directory?(config.hook_path(identifier))
            # already fetched, do nothing
            return
          else
            error "Can't identify hook source from identifier: #{identifier}"
          end

          hook_name = source.hook_name

          say "Fetching hook #{source.hook_name}..."
          source.fetch(config.hook_path(source.hook_name))
        end
      end
    end
  end
end
