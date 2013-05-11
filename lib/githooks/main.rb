require 'fileutils'
require 'githooks/run'

# TODO (2013-05-11) Potential new objects: Config, Run
# TODO (2013-05-11) "Usage" per-command
module Githooks
  class Main
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
        Run.call(@args)
      end
    end
  end
end
