require 'simplecov'

SimpleCov.start

require 'pp'
require 'fileutils'
require 'tmpdir'
require 'support'
require 'githooks/main'

Githooks::Config.hooks_root = Support.hooks_root

RSpec.configure do |config|
  config.include Support

  config.around do |example|
    Dir.mktmpdir do |dir|
      FileUtils.cd(dir) do
        example.run
      end
    end
  end
end
