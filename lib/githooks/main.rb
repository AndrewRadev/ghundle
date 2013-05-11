require 'fileutils'

# TODO (2013-05-11) Potential new objects: Config, Run
# TODO (2013-05-11) "Usage" per-command
module Githooks
  class Main
    @@hooks_root = File.expand_path('~/.githooks/')

    def self.hooks_root
      @@hooks_root
    end

    def self.hooks_root=(path)
      @@hooks_root = path
    end

    def self.exec(*args)
      new(*args).exec
    end

    def initialize(*args)
      @command = args.shift
      @args    = args
    end

    def exec
      case @command
      when 'run'
        hook_name = @args.first

        if not hook_name
          raise "No hook name given"
        end

        script_path = hook_path(hook_name)

        if not File.exist?(script_path)
          raise "The file `#{script_path}` doesn't exist"
        end

        if not File.executable?(script_path)
          raise "The file `#{script_path}` is not executable"
        end

        system(script_path)
      end
    end

    private

    def hook_path(hook_name)
      if not File.directory?(self.class.hooks_root)
        FileUtils.mkdir_p(self.class.hooks_root)
      end

      File.join(self.class.hooks_root, hook_name)
    end
  end
end
