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

    def possible_hook_types
      %w{
        applypatch-msg
        commit-msg
        post-applypatch
        post-checkout
        post-commit
        post-merge
        post-receive
        post-rewrite
        post-update
        pre-applypatch
        pre-auto-gc
        pre-commit
        pre-push
        pre-rebase
        pre-receive
        prepare-commit-msg
        update
      }
    end
  end
end
