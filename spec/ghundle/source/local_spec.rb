require 'spec_helper'
require 'ghundle/source/local'

module Ghundle
  module Source
    describe Local do
      let(:source) { Local.new(Support.hooks_root.join('test-script')) }

      before :each do
        create_script(Support.hooks_root.join('test-script'), <<-EOF)
          #! /bin/sh
          echo "OK"
        EOF
        create_metadata(Support.hooks_root.join('test-script'), 'description' => 'One two three')
      end

      it "fetches the metadata from the local script" do
        expect(source.metadata.description).to eq 'One two three'
      end

      it "doesn't do anything when fetching" do
        source.fetch
      end

      describe "(validation)" do
        it "validates the presence of the script" do
          source.validate

          Support.hooks_root.join('test-script/run').unlink
          expect { source.validate }.to raise_error AppError
        end

        it "validates that the script is executable" do
          source.validate

          File.chmod 0644, Support.hooks_root.join('test-script/run')
          expect { source.validate }.to raise_error AppError
        end

        it "validates the presence of the metadata file" do
          source.validate

          Support.hooks_root.join('test-script/meta.yml').unlink
          expect { source.validate }.to raise_error AppError
        end
      end
    end
  end
end
