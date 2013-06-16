require 'spec_helper'
require 'githooks/source/local'

module Githooks
  module Source
    describe Local do
      let(:source) { Local.new('test-script') }

      before :each do
        create_script(Support.hooks_root.join('test-script'), <<-EOF)
          #! /bin/sh
          echo "OK"
        EOF
        create_metadata(Support.hooks_root.join('test-script'), 'description' => 'One two three')
      end

      it "fetches the metadata from the local script" do
        source.metadata.description.should eq 'One two three'
      end

      it "doesn't do anything when fetching" do
        source.fetch
      end
    end
  end
end
