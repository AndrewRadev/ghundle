require 'spec_helper'
require 'ghundle/source/github'

module Ghundle
  module Source
    describe Github do
      let(:source) { Github.new('github.com/user/repo/path/to/test-hook') }

      let(:github_root)  { 'https://raw.github.com/user/repo/master' }
      let(:script_url)   { "#{github_root}/path/to/test-hook/run" }
      let(:metadata_url) { "#{github_root}/path/to/test-hook/meta.yml" }

      before :each do
        metadata = test_metadata('description' => 'remote metadata')
        FakeWeb.register_uri(:get, metadata_url, :body => YAML.dump(metadata))
        FakeWeb.register_uri(:get, script_url, :body => <<-EOF)
          #! /bin/sh
          echo "OK"
        EOF
      end

      it "fetches the metadata from the remote file" do
        expect(source.metadata.description).to eq 'remote metadata'
      end

      it "fetches the remote files locally" do
        expect(Support.hooks_root.join("test-hook")).to_not be_directory

        source.fetch(Support.hooks_root.join("test-hook"))

        expect(Support.hooks_root.join("test-hook")).to be_directory
        expect(Support.hooks_root.join("test-hook/run")).to be_executable
        expect(Support.hooks_root.join("test-hook/meta.yml")).to be_file
      end

      it "can fetch twice to the same location" do
        source.fetch(Support.hooks_root.join("test-hook"))
        source.fetch(Support.hooks_root.join("test-hook"))
      end

      it "returns a fetched local source" do
        expect(source.fetch(Support.hooks_root.join("test-hook")).exists?).to be_truthy
      end

      describe "(validation)" do
        it "validates the presence of the script" do
          FakeWeb.register_uri(:get, script_url, :status => 404)
          expect { source.fetch('stub') }.to raise_error AppError
        end

        it "validates the presence of the metadata file" do
          FakeWeb.register_uri(:get, metadata_url, :status => 404)
          expect { source.metadata }.to raise_error AppError
        end
      end

      describe "(representation)" do
        it "looks like its path" do
          source.to_s.should eq "path/to/test-hook"
        end
      end
    end
  end
end
