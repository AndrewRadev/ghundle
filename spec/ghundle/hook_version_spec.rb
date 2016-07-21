require 'spec_helper'
require 'ghundle/hook_version'

module Ghundle
  describe HookVersion do
    def version(string)
      HookVersion.new(string)
    end

    it "allows comparison between hook versions" do
      expect(version('1.0.0')).to eq version('1.0.0')
      expect(version('1.0.0')).to_not eq version('0.1.0')

      expect(version('1.0.0')).to be > version('0.1.0')
      expect(version('0.1.2')).to be > version('0.1.1')
      expect(version('0.2.1')).to be > version('0.1.3')
    end
  end
end
