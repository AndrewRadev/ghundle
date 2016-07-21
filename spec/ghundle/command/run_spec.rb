require 'spec_helper'
require 'ghundle/command/run'

module Ghundle
  module Command
    describe Run do
      it "can run a script" do
        create_script(hook_path('test-hook'), <<-EOF)
          #! /bin/sh
          echo "OK" > test-hook-result
        EOF
        create_metadata(hook_path('test-hook'))

        Run.call('test-hook')

        File.exists?('test-hook-result').should be_truthy
        File.read('test-hook-result').strip.should eq 'OK'
      end

      it "gives the positional arguments to the script" do
        create_script(hook_path('test-hook'), <<-EOF)
          #! /bin/sh
          echo "$1 + $2" > test-hook-result
        EOF
        create_metadata(hook_path('test-hook'))

        Run.call('test-hook', 'one', 'two')

        File.exists?('test-hook-result').should be_truthy
        File.read('test-hook-result').strip.should eq 'one + two'
      end
    end
  end
end
