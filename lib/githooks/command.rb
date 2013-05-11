require 'githooks/config'

module Githooks
  class Command
    attr_reader :args

    def self.call(*args)
      new(*args).call
    end

    def initialize(*args)
      @args = args
    end

    private

    def say(message)
      puts ">> #{message}"
    end

    def error(*args)
      raise AppError.new(*args)
    end

    def config
      @config ||= Githooks::Config
    end
  end
end
