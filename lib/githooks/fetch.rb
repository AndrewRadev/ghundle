require 'yaml'

module Githooks
  class Fetch
    def self.call(*args)
      new(*args).call
    end

    def initialize(*args)
      @args = args
    end

    def call
      path      = @args.first
      hook_name = File.basename(path)

      if not path
        raise AppError.new("No path given (TODO usage)")
      end

      if not File.directory?(path)
        raise AppError.new("Directory `#{path}` doesn't exist")
      end

      if not File.exist?("#{path}/meta.yml") or not File.exist?("#{path}/run")
        raise AppError.new("Structure of #{path} does not comply with requirements, see documentation (TODO documentation)")
      end

      meta      = YAML.load_file("#{path}/meta.yml")
      hook_type = meta['type']

      if not hook_type
        raise AppError.new("No :type key found in `#{path}/meta.yml`")
      end

      destination_path = config.hook_path("#{hook_type}/#{hook_name}")

      FileUtils.mkdir_p(File.dirname(destination_path))
      FileUtils.cp "#{path}/run", destination_path
    end

    private

    def config
      @config ||= Githooks::Config
    end
  end
end
