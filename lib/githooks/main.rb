require 'fileutils'
require 'githooks/run'
require 'githooks/fetch'

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
      when 'run' then Run.call(*@args)
      when 'fetch' then Fetch.call(*@args)
      end
    end
  end
end
