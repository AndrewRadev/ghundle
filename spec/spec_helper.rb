require 'fakeweb'
require 'simplecov'

SimpleCov.start

require 'pp'
require 'fileutils'
require 'tmpdir'
require 'support'
require 'ghundle/main'

Ghundle::Config.hooks_root = Support.hooks_root

class Ghundle::Command::Common
  def say(*args)
    # stubbed out in test mode
  end
end

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
