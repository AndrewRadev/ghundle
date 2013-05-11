require 'fileutils'
require 'githooks/run'

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
        Run.call(*@args)
      end
    end
  end
end
