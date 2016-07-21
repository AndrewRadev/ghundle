require 'spec_helper'
require 'ghundle/command/list_installed'

module Ghundle
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

        expect(instance.output).to include 'one'
        expect(instance.output).to include 'two'
        expect(instance.output).to_not include 'three'
      end

      it "runs as expected" do
        install_hook('one')
        stdout, stderr = capture_io { instance.call }
        stdout.should_not be_empty
        stderr.should be_empty
      end

      it "shows hook descriptions" do
        install_hook('one', 'description' => 'A test hook')
        expect(instance.output).to include 'A test hook'
      end

      it "notifies for broken hooks" do
        write_file('.git/hooks/post-merge', [
          '#! /bin/sh',
          'ghundle run nonexistent $*',
        ].join("\n"))

        expect(instance.output).to include 'Hook `nonexistent` does not exist'
      end

      it "shows each hook only once per installed file" do
        install_hook('one', {
          'types'       => ['post-merge', 'pre-receive'],
          'description' => 'A test hook',
        })
        expect(instance.output.split("\n").grep(/A test hook/).length).to eq 1
      end
    end
  end
end
