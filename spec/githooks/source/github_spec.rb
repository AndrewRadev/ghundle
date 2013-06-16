require 'spec_helper'
require 'githooks/source/github'

module Githooks
  module Source
    describe Github do
      let(:source) { Github.new('github.com/user/repo/path/to/test-hook') }

      before :each do
        github_root = 'https://raw.github.com/user/repo/master'
        metadata = test_metadata('description' => 'remote metadata')
        FakeWeb.register_uri(:get, "#{github_root}/path/to/test-hook/meta.yml", :body => YAML.dump(metadata))
        FakeWeb.register_uri(:get, "#{github_root}/path/to/test-hook/run", :body => <<-EOF)
          #! /bin/sh
          echo "OK"
        EOF
      end

      it "fetches the metadata from the remote file" do
        source.metadata.description.should eq 'remote metadata'
      end

      it "doesn't do anything when fetching" do
        Support.hooks_root.join("test-hook").should_not be_directory

        source.fetch(Support.hooks_root.join("test-hook"))

        Support.hooks_root.join("test-hook").should be_directory
        Support.hooks_root.join("test-hook/run").should be_executable
        Support.hooks_root.join("test-hook/meta.yml").should be_file
      end
    end
  end
end
