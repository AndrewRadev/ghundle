require 'spec_helper'
require 'githooks/source/directory'

module Githooks
  module Source
    describe Directory do
      let(:source) { Directory.new('test-dir/test-script') }

      before :each do
        create_script('test-dir/test-script', <<-EOF)
          #! /bin/sh
          echo "OK"
        EOF
        create_metadata('test-dir/test-script', 'description' => 'One two three')
      end

      it "fetches the metadata from the local script" do
        source.metadata.description.should eq 'One two three'
      end

      it "copies the relevant file to the hook root" do
        Support.hooks_root.join("test-script").should_not be_directory

        source.fetch(Support.hooks_root.join("test-script"))

        Support.hooks_root.join("test-script").should be_directory
        Support.hooks_root.join("test-script/run").should be_executable
        Support.hooks_root.join("test-script/meta.yml").should be_file
      end

      it "can fetch twice to the same location" do
        source.fetch(Support.hooks_root.join("test-script"))
        source.fetch(Support.hooks_root.join("test-script"))
      end

      it "returns a fetched local source" do
        source.fetch(Support.hooks_root.join("test-script")).exists?.should be_true
      end

      describe "(validation)" do
        it "validates the presence of the script" do
          source.validate

          Pathname.new('test-dir/test-script/run').unlink
          expect { source.validate }.to raise_error
        end

        it "validates that the script is executable" do
          source.validate

          File.chmod 0644, 'test-dir/test-script/run'
          expect { source.validate }.to raise_error
        end

        it "validates the presence of the metadata file" do
          source.validate

          Pathname.new('test-dir/test-script/meta.yml').unlink
          expect { source.validate }.to raise_error
        end
      end
    end
  end
end
