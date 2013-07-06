require 'spec_helper'
require 'githooks/command/list_installed'

module Githooks
  module Command
    describe ListInstalled do
      let(:instance) { ListInstalled.new }

      before :each do
        FileUtils.mkdir_p '.git/hooks'
      end

      def install_hook(name, metadata = {})
        create_script(hook_path(name))
        create_metadata(hook_path(name), metadata)
        Install.call(name)
      end

      it "lists all hooks installed in the local repo" do
        install_hook('one')
        install_hook('two')
        create_script(hook_path('three'))
        create_metadata(hook_path('three'))

        instance.output.should include 'one'
        instance.output.should include 'two'
        instance.output.should_not include 'three'
      end

      it "shows hook descriptions" do
        install_hook('one', 'description' => 'A test hook')
        instance.output.should include 'A test hook'
      end

      it "notifies for broken hooks" do
        write_file('.git/hooks/post-merge', [
          '#! /bin/sh',
          'githooks run nonexistent $*',
        ].join("\n"))

        instance.output.should include 'Hook `nonexistent` does not exist'
      end
    end
  end
end
