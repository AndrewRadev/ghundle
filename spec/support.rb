require 'fileutils'

module Support
  def self.hooks_root
    'test-githooks'
  end

  def create_test_script(name, contents)
    filename = File.join(Support.hooks_root, name)

    ensure_parent_directory(filename)
    write_file(filename, contents)
    make_executable(filename)
  end

  def ensure_parent_directory(filename)
    FileUtils.mkdir_p(File.dirname(filename))
  end

  def write_file(filename, contents)
    File.open(filename, 'w') { |f| f.write(contents) }
  end

  def make_executable(filename)
    File.chmod(0755, filename)
  end

  def expect_hook_exists(hook_name)
    filename = File.join(Support.hooks_root, hook_name)
    File.exists?(filename).should be_true
    File.executable?(filename).should be_true
  end
end
