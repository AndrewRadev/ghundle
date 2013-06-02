require 'spec_helper'
require 'githooks/hook'

module Githooks
  describe Hook do
    describe ".from_local_source" do
      before :each do
        ensure_parent_directory 'local/test-hook/run'
        write_file('local/test-hook/meta.yml', YAML.dump('type' => 'post-merge'))
        write_file('local/test-hook/run', <<-EOF)
          #! /bin/sh
          echo "OK"
        EOF
        make_executable 'local/test-hook/run'
      end

      it "instantiates a hook with a pointer to the source" do
        hook = Hook.from_local_source('local/test-hook')

        hook.name.should eq 'test-hook'
        hook.type.should eq 'post-merge'
        hook.source.path.should eq Pathname.new('local/test-hook')
      end

      it "can be fetched to a cached location" do
        hook = Hook.from_local_source('local/test-hook')
        hook.should_not be_cached

        hook.fetch
        hook.should be_cached
      end
    end

    describe ".from_github_source" do
      before :each do
        github_root = 'https://raw.github.com/AndrewRadev/githooks/master'
        FakeWeb.register_uri(:get, "#{github_root}/hooks/ctags/meta.yml", :body => YAML.dump('type' => 'post-merge'))
        FakeWeb.register_uri(:get, "#{github_root}/hooks/ctags/run", :body => <<-EOF)
          #! /bin/sh
          echo "OK"
        EOF
      end

      it "can be fetched from a remote location" do
        hook = Hook.from_github_source('AndrewRadev/githooks:hooks/ctags')
        hook.should_not be_cached

        hook.fetch
        hook.should be_cached
      end
    end
  end
end
