require 'fileutils'

module Support
  def self.hooks_root
    'test-githooks'
  end

  def create_test_script(name, contents)
    filename = File.join(Support.hooks_root, name)

    FileUtils.mkdir_p(File.dirname(filename))
    File.open(filename, 'w') { |f| f.write(contents) }
    File.chmod(0755, filename)
  end
end
