require 'yaml'
require 'githooks/command'

module Githooks
  module Command
    # Tries to figure out what kind of a source the given identifier represents
    # and fetches the hook locally.
    #
    class Fetch < Common
      def call
        identifier = args.first

        if identifier =~ /^github.com/
          source = Source.github(identifier)
        elsif File.directory?(identifier)
          source = Source.directory(identifier)
        elsif File.directory?(config.hook_path(identifier))
          source = Source.local(identifier)
        else
          error "Can't identify hook source from identifier: #{identifier}"
        end

        validate_path(path)

        hook_name = File.basename(path)
        meta      = YAML.load_file("#{path}/meta.yml")

        validate_metadata(meta)

        hook_type = meta['type']

        destination_path = config.hook_path("#{hook_type}/#{hook_name}")

        say "Copying hook to #{destination_path}..."
        FileUtils.mkdir_p(File.dirname(destination_path))
        FileUtils.cp "#{path}/run", destination_path
      end

      def validate_path(path)
        if not path
          error "No path given (TODO usage)"
        end

        if not File.directory?(path)
          error "Directory `#{path}` doesn't exist"
        end

        if not File.exist?("#{path}/meta.yml") or not File.exist?("#{path}/run")
          error "Structure of #{path} does not comply with requirements, see documentation (TODO documentation)"
        end
      end

      def validate_metadata(data)
        if not data
          error "No metadata found."
        end

        if not data['type']
          error "No 'type' key found in metadata."
        end

        if not possible_hook_types.include?(data['type'])
          error "The type of the script needs to be one of: #{possible_hook_types.join(', ')}."
        end
      end
    end
  end
end
