require 'spec_helper'
require 'githooks/command/install'

module Githooks
  module Command
    describe Install do
      let(:instance) { Install.new }

      before :each do
        FileUtils.mkdir_p '.git/hooks'
      end

      it "creates a git hook file if one does not exist" do
        create_script(hook_path('foo'))
        create_metadata(hook_path('foo'), 'type' => 'post-merge')

        Install.call('foo')

        File.exists?('.git/hooks/post-merge').should be_true
        File.executable?('.git/hooks/post-merge').should be_true
      end

      it "adds the hooks to the git hook file" do
        create_script(hook_path('foo'))
        create_metadata(hook_path('foo'), 'type' => 'post-merge')

        Install.call('foo')

        hook_file = File.read('.git/hooks/post-merge')
        hook_file.should include 'githooks run foo $*'
      end
    end
  end
end
