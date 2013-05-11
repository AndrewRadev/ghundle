require 'spec_helper'
require 'githooks/main'

module Githooks
  describe Main do
    it "can run a script" do
      create_test_script('post-merge/test-hook', <<-EOF)
        #! /bin/sh
        echo "OK" > test-hook-result
      EOF

      Main.exec('run', 'post-merge/test-hook')

      File.exists?('test-hook-result').should be_true
      File.read('test-hook-result').strip.should eq 'OK'
    end
  end
end
