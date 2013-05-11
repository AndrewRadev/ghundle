require 'spec_helper'
require 'githooks/fetch'

module Githooks
  describe Fetch do
    describe "local path" do
      let(:instance) { Fetch.new }

      it "fetches a git hook from a local directory and puts it in its right place" do
        ensure_parent_directory 'hook-source/test-hook/run'
        write_file('hook-source/test-hook/meta.yml', YAML.dump('type' => 'post-merge'))
        write_file('hook-source/test-hook/run', <<-EOF)
          #! /bin/sh
          echo "OK"
        EOF
        make_executable 'hook-source/test-hook/run'

        Fetch.call('hook-source/test-hook')

        expect_hook_exists 'post-merge/test-hook'
      end

      it "validates the given local path" do
        expect { instance.validate_path(nil) }.to raise_error(AppError)
        expect { instance.validate_path('nonexistent') }.to raise_error(AppError)

        FileUtils.mkdir_p 'root'
        expect { instance.validate_path('root') }.to raise_error(AppError)

        FileUtils.touch 'root/meta.yml'
        expect { instance.validate_path('root') }.to raise_error(AppError)

        FileUtils.touch 'root/run'
        instance.validate_path('root')
      end

      it "validates the script's metadata" do
        expect {
          instance.validate_metadata(nil)
        }.to raise_error(AppError)

        expect {
          instance.validate_metadata('foo' => 'bar')
        }.to raise_error(AppError)

        expect {
          instance.validate_metadata('type' => 'nonexistent')
        }.to raise_error(AppError)

        instance.validate_metadata('type' => 'update')
      end
    end
  end
end
