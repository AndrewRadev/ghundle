require 'spec_helper'
require 'ghundle/command/install'

module Ghundle
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
        expect(IO.read('.git/hooks/post-merge')).to include 'ghundle run foo'

        Uninstall.call('foo')
        expect(IO.read('.git/hooks/post-merge')).to_not include 'ghundle run foo'
      end

      it "is idempotent" do
        Uninstall.call('foo')
        Uninstall.call('foo')
      end
    end
  end
end
