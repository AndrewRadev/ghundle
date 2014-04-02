require 'spec_helper'
require 'ghundle/main'

module Ghundle
  describe Main do
    it "delegates to run" do
      Command::Run.should_receive(:call).with('test-hook', 'test-argument')
      Main.exec('run', 'test-hook', 'test-argument')
    end

    it "delegates to fetch" do
      Command::Fetch.should_receive(:call).with('/path/to/test-hook-source')
      Main.exec('fetch', '/path/to/test-hook-source')
    end

    it "delegates to install" do
      Command::Install.should_receive(:call).with('hook-name')
      Main.exec('install', 'hook-name')
    end

    it "delegates to list-all" do
      Command::ListAll.should_receive(:call)
      Main.exec('list-all')
    end

    it "delegates to uninstall" do
      Command::Uninstall.should_receive(:call).with('hook-name')
      Main.exec('uninstall', 'hook-name')
    end

    it "delegates to list-installed" do
      Command::ListInstalled.should_receive(:call)
      Main.exec('list-installed')
    end

    it "complains if there's an invalid command" do
      expect(-> { Main.exec('ass', 'fishfingers') }).to raise_error(AppError)
    end
  end
end
