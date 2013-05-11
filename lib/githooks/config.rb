module Githooks
  module Config
    extend self

    attr_accessor :hooks_root

    def hooks_root
      @hooks_root || File.expand_path('~/.githooks/')
    end

    def hook_path(hook_name)
      if not File.directory?(hooks_root)
        FileUtils.mkdir_p(hooks_root)
      end

      File.join(hooks_root, hook_name)
    end
  end
end
