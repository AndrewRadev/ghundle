require 'githooks/command'
require 'githooks/app_error'

# TODO (2013-05-11) "Usage" per-command
module Githooks
  class Run < Command
    def call
      hook_name = args.first

      if not hook_name
        error "No hook name given"
      end

      script_path = config.hook_path(hook_name)

      if not File.exist?(script_path)
        error "The file `#{script_path}` doesn't exist"
      end

      if not File.executable?(script_path)
        error "The file `#{script_path}` is not executable"
      end

      say "Running hook #{hook_name}"
      system(script_path, *@args[1 .. -1])
    end
  end
end
