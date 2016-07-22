require 'spec_helper'
require 'ghundle/command/list_all'

module Ghundle
  module Command
    describe ListAll do
      let(:instance) { ListAll.new }

      it "runs as expected" do
        stdout, stderr = capture_io { instance.call }
        expect(stdout).to_not be_empty
        expect(stderr).to be_empty
      end

      it "lists all available hooks in the hook root" do
        create_script(hook_path('one'))
        create_metadata(hook_path('one'))
        create_script(hook_path('two'))
        create_metadata(hook_path('two'))

        expect(instance.output).to include 'one'
        expect(instance.output).to include 'two'
      end

      it "shows hook descriptions" do
        create_script(hook_path('one'))
        create_metadata(hook_path('one'), 'description' => 'A test hook')

        expect(instance.output).to include 'A test hook'
      end

      it "ignores non-directories in the hook root" do
        create_script(hook_path('one'))
        create_metadata(hook_path('one'))
        File.open(hook_path('non-directory'), 'w') { |f| f.write('foo') }

        expect(instance.output).to_not include 'non-directory'
      end
    end
  end
end
