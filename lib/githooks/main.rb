require 'githooks/command'

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
      when 'run'     then Command::Run.call(*@args)
      when 'fetch'   then Command::Fetch.call(*@args)
      when 'install' then Command::Install.call(*@args)
      end
    end
  end
end
