require 'spec_helper'
require 'githooks/hook_version'

module Githooks
  describe HookVersion do
    def version(string)
      HookVersion.new(string)
    end

    it "allows comparison between hook versions" do
      version('1.0.0').should eq version('1.0.0')
      version('1.0.0').should_not eq version('0.1.0')

      version('1.0.0').should be > version('0.1.0')
      version('0.1.2').should be > version('0.1.1')
      version('0.2.1').should be > version('0.1.3')
    end
  end
end
