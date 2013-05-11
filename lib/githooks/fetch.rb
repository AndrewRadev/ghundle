require 'yaml'
require 'githooks/command'

module Githooks
  class Fetch < Command
    def call
      path = args.first

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
