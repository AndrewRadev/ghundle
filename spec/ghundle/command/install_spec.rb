require 'spec_helper'
require 'ghundle/command/install'

module Ghundle
  module Command
    describe Install do
      let(:instance) { Install.new }

      before :each do
        FileUtils.mkdir_p '.git/hooks'
      end

      it "creates a git hook file if one does not exist" do
        create_script(hook_path('foo'))
        create_metadata(hook_path('foo'), 'types' => ['post-merge'])

        Install.call('foo')

        File.exists?('.git/hooks/post-merge').should be_true
        File.executable?('.git/hooks/post-merge').should be_true
      end

      it "can create multiple hooks" do
        create_script(hook_path('one'))
        create_metadata(hook_path('one'), 'types' => ['post-merge'])
        create_script(hook_path('two'))
        create_metadata(hook_path('two'), 'types' => ['post-checkout'])

        Install.call('one', 'two')

        File.executable?('.git/hooks/post-merge').should be_true
        File.executable?('.git/hooks/post-checkout').should be_true
      end

      it "adds the hooks to the relevant git hook files" do
        create_script(hook_path('foo'))
        create_metadata(hook_path('foo'), 'types' => ['post-merge', 'pre-receive'])

        Install.call('foo')

        File.read('.git/hooks/post-merge').should include 'ghundle run foo $*'
        File.read('.git/hooks/pre-receive').should include 'ghundle run foo $*'
      end
    end
  end
end
