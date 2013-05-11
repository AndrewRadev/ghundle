require 'githooks/config'
require 'githooks/app_error'

module Githooks
  class Run
    def self.call(args)
      new(args).call
    end

    def initialize(args)
      @args = args
    end

    def call
      hook_name = @args.first

      if not hook_name
        raise AppError.new("No hook name given")
      end

      script_path = config.hook_path(hook_name)

      if not File.exist?(script_path)
        raise AppError.new("The file `#{script_path}` doesn't exist")
      end

      if not File.executable?(script_path)
        raise AppError.new("The file `#{script_path}` is not executable")
      end

      system(script_path)
    end

    private

    def config
      @config ||= Githooks::Config
    end
  end
end
