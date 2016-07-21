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

        expect(File.exists?('test-hook-result')).to be_truthy
        expect(File.read('test-hook-result').strip).to eq 'OK'
      end

      it "gives the positional arguments to the script" do
        create_script(hook_path('test-hook'), <<-EOF)
          #! /bin/sh
          echo "$1 + $2" > test-hook-result
        EOF
        create_metadata(hook_path('test-hook'))

        Run.call('test-hook', 'one', 'two')

        expect(File.exists?('test-hook-result')).to be_truthy
        expect(File.read('test-hook-result').strip).to eq 'one + two'
      end
    end
  end
end
