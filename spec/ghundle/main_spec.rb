require 'spec_helper'
require 'ghundle/main'

module Ghundle
  describe Main do
    it "delegates to run" do
      expect(Command::Run).to receive(:call).with('test-hook', 'test-argument')
      Main.exec('run', 'test-hook', 'test-argument')
    end

    it "delegates to fetch" do
      expect(Command::Fetch).to receive(:call).with('/path/to/test-hook-source')
      Main.exec('fetch', '/path/to/test-hook-source')
    end

    it "delegates to install" do
      expect(Command::Install).to receive(:call).with('hook-name')
      Main.exec('install', 'hook-name')
    end

    it "delegates to list-all" do
      expect(Command::ListAll).to receive(:call)
      Main.exec('list-all')
    end

    it "delegates to uninstall" do
      expect(Command::Uninstall).to receive(:call).with('hook-name')
      Main.exec('uninstall', 'hook-name')
    end

    it "delegates to list-installed" do
      expect(Command::ListInstalled).to receive(:call)
      Main.exec('list-installed')
    end

    it "complains if there's an invalid command" do
      expect(-> { Main.exec('ass', 'fishfingers') }).to raise_error(AppError)
    end
  end
end
