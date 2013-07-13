require 'spec_helper'
require 'githooks/command/install'

module Githooks
  module Command
    describe Uninstall do
      let(:instance) { Uninstall.new }

      before :each do
        FileUtils.mkdir_p '.git/hooks'
        create_script(hook_path('foo'))
        create_metadata(hook_path('foo'), 'types' => ['post-merge'])
        Install.call('foo')
      end

      it "removes the hook from its hook file" do
        IO.read('.git/hooks/post-merge').should include 'githooks run foo'

        Uninstall.call('foo')
        IO.read('.git/hooks/post-merge').should_not include 'githooks run foo'
      end

      it "is idempotent" do
        Uninstall.call('foo')
        Uninstall.call('foo')
      end
    end
  end
end
