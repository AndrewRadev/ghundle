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

        expect(File.exists?('.git/hooks/post-merge')).to be_truthy
        expect(File.executable?('.git/hooks/post-merge')).to be_truthy
      end

      it "can create multiple hooks" do
        create_script(hook_path('one'))
        create_metadata(hook_path('one'), 'types' => ['post-merge'])
        create_script(hook_path('two'))
        create_metadata(hook_path('two'), 'types' => ['post-checkout'])

        Install.call('one', 'two')

        expect(File.executable?('.git/hooks/post-merge')).to be_truthy
        expect(File.executable?('.git/hooks/post-checkout')).to be_truthy
      end

      it "adds the hooks to the relevant git hook files" do
        create_script(hook_path('foo'))
        create_metadata(hook_path('foo'), 'types' => ['post-merge', 'pre-receive'])

        Install.call('foo')

        expect(File.read('.git/hooks/post-merge')).to include 'ghundle run foo $*'
        expect(File.read('.git/hooks/pre-receive')).to include 'ghundle run foo $*'
      end
    end
  end
end
