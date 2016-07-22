require 'spec_helper'
require 'ghundle/source/directory'

module Ghundle
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
        expect(source.metadata.description).to eq 'One two three'
      end

      it "copies the relevant file to the hook root" do
        expect(Support.hooks_root.join("test-script")).to_not be_directory

        source.fetch(Support.hooks_root.join("test-script"))

        expect(Support.hooks_root.join("test-script")).to be_directory
        expect(Support.hooks_root.join("test-script/run")).to be_executable
        expect(Support.hooks_root.join("test-script/meta.yml")).to be_file
      end

      it "can fetch twice to the same location" do
        source.fetch(Support.hooks_root.join("test-script"))
        source.fetch(Support.hooks_root.join("test-script"))
      end

      it "returns a fetched local source" do
        expect(source.fetch(Support.hooks_root.join("test-script")).exists?).to be_truthy
      end

      describe "(validation)" do
        it "validates the presence of the script" do
          source.validate

          Pathname.new('test-dir/test-script/run').unlink
          expect { source.validate }.to raise_error AppError
        end

        it "validates that the script is executable" do
          source.validate

          File.chmod 0644, 'test-dir/test-script/run'
          expect { source.validate }.to raise_error AppError
        end

        it "validates the presence of the metadata file" do
          source.validate

          Pathname.new('test-dir/test-script/meta.yml').unlink
          expect { source.validate }.to raise_error AppError
        end
      end

      describe "(representation)" do
        it "looks like its hook name" do
          expect(source.to_s).to eq "test-dir/test-script"
        end
      end
    end
  end
end
