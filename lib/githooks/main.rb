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
      when 'fetch'     then Command::Fetch.call(*@args)
      when 'install'   then Command::Install.call(*@args)
      when 'list-all'  then Command::ListAll.call(*@args)
      when 'run'       then Command::Run.call(*@args)
      when 'uninstall' then Command::Uninstall.call(*@args)
      else
        raise AppError.new("Unknown command: #{@command}")
      end
    end
  end
end
