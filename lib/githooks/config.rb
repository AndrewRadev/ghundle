module Githooks
  module Config
    extend self

    attr_accessor :hooks_root

    def hooks_root
      @hooks_root || Pathname.new(File.expand_path('~/.githooks/'))
    end

    def hook_path(hook_name)
      if not hooks_root.directory?
        FileUtils.mkdir_p(hooks_root)
      end

      hooks_root.join(hook_name)
    end
  end
end
