require 'githooks/source/directory'
require 'githooks/source/github'
require 'githooks/source/local'

module Githooks
  module Source
    extend self

    def directory(path)
      name     = File.basename(path)
      source   = Directory.new(path)
      metadata = source.metadata

      new(name, metadata, source)
    end

    # <username>/<repo>:<path>
    def github(description)
      source   = Github.new(description)
      name     = source.script_name
      metadata = source.metadata

      new(name, metadata, source)
    end

    def local(hook_name)
      # validate
    end
  end
end
