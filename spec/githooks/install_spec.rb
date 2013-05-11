require 'spec_helper'
require 'githooks/install'

module Githooks
  describe Install do
    let(:instance) { Install.new }

    before :each do
      FileUtils.mkdir_p '.git/hooks'
    end

    it "creates a git hook file if one does not exist" do
      create_test_script 'post-merge/foo', ''
      Install.call('post-merge/foo')

      File.exists?('.git/hooks/post-merge').should be_true
      File.executable?('.git/hooks/post-merge').should be_true
    end

    it "Adds the hooks to the git hook file" do
      create_test_script 'post-merge/foo', ''
      Install.call('post-merge/foo')

      hook_file = File.read('.git/hooks/post-merge')
      hook_file.should include 'githooks run post-merge/foo $*'
    end

    describe "#validate_hook" do
      it "validates the given hook" do
        expect { instance.validate_hook(nil) }.to raise_error(AppError)
        expect { instance.validate_hook('script-name') }.to raise_error(AppError)

        create_test_script('script-name', '')
        instance.validate_hook('script-name')
      end
    end
  end
end
