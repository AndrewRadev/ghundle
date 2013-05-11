require 'spec_helper'
require 'githooks/fetch'

module Githooks
  describe Fetch do
    it "fetches a git hook from a local directory and puts it in its right place" do
      ensure_parent_directory 'hook-source/test-hook/run'
      write_file('hook-source/test-hook/meta.yml', <<EOF)
---
type: pre-merge
EOF
      write_file('hook-source/test-hook/run', <<-EOF)
        #! /bin/sh
        echo "OK"
      EOF
      make_executable 'hook-source/test-hook/run'

      Fetch.call('hook-source/test-hook')

      expect_hook_exists 'pre-merge/test-hook'
    end
  end
end
