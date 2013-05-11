require 'spec_helper'
require 'githooks/main'

module Githooks
  describe Main do
    it "delegates to run" do
      Run.should_receive(:call).with('post-merge/test-hook', 'test-argument')
      Main.exec('run', 'post-merge/test-hook', 'test-argument')
    end

    it "delegates to fetch" do
      Fetch.should_receive(:call).with('/path/to/test-hook-source')
      Main.exec('fetch', '/path/to/test-hook-source')
    end
  end
end
