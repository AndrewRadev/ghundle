require 'spec_helper'
require 'githooks/main'

module Githooks
  describe Main do
    it "delegates to run" do
      Run.should_receive(:call).with('post-merge/test-hook', 'test-argument')
      Main.exec('run', 'post-merge/test-hook', 'test-argument')
    end
  end
end
