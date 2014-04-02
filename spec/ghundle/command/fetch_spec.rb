require 'spec_helper'
require 'ghundle/command/fetch'

module Ghundle
  module Command
    describe Fetch do
      describe "(local path)" do
        it "fetches a git hook from a local directory and puts it in its right place" do
          ensure_parent_directory 'hook-source/test-hook/run'
          create_metadata('hook-source/test-hook', 'types' => ['post-merge'])
          create_script('hook-source/test-hook', <<-EOF)
            #! /bin/sh
            echo "OK"
          EOF

          Fetch.call('hook-source/test-hook')

          expect_hook_exists 'test-hook'
        end

        it "can fetch multiple hooks" do
          create_metadata('hook-source/first-hook')
          create_script('hook-source/first-hook')
          create_metadata('hook-source/second-hook')
          create_script('hook-source/second-hook')

          Fetch.call('hook-source/first-hook', 'hook-source/second-hook')

          expect_hook_exists 'first-hook'
          expect_hook_exists 'second-hook'
        end
      end

      describe "(github url)" do
        it "fetches a git hook from github and puts it in its right place" do
          github_root  = 'https://raw.github.com/user/repo/master'
          script_url   = "#{github_root}/path/to/test-hook/run"
          metadata_url = "#{github_root}/path/to/test-hook/meta.yml"

          metadata = test_metadata('description' => 'remote metadata')
          FakeWeb.register_uri(:get, metadata_url, :body => YAML.dump(metadata))
          FakeWeb.register_uri(:get, script_url, :body => <<-EOF)
            #! /bin/sh
            echo "OK"
          EOF

          Fetch.call('github.com/user/repo/path/to/test-hook')

          expect_hook_exists 'test-hook'
        end
      end

      describe "(local script)" do
        it "does nothing for a locally fetched script" do
          create_script(Support.hooks_root.join('test-script'))
          create_metadata(Support.hooks_root.join('test-script'))

          Fetch.call('test-script')
        end
      end

      describe "(invalid input)" do
        it "complains helpfully" do
          expect(-> { Fetch.call('broken glass') }).to raise_error(AppError)
        end
      end
    end
  end
end
