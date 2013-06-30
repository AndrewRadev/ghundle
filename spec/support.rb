require 'fileutils'

module Support
  def self.hooks_root
    Pathname.new('test-githooks')
  end

  def hook_path(path)
    Support.hooks_root.join(path)
  end

  def create_script(name, contents = nil)
    filename = File.join(name, 'run')
    contents ||= <<-EOF
      #! /bin/sh
      echo "OK"
    EOF

    ensure_parent_directory(filename)
    write_file(filename, contents)
    make_executable(filename)
  end

  def create_metadata(name, data = {})
    data = test_metadata(data)
    filename = File.join(name, 'meta.yml')

    ensure_parent_directory(filename)
    write_file(filename, YAML.dump(data))
  end

  def test_metadata(overrides = {})
    {
      'type'        => 'post-checkout',
      'version'     => '0.0.0',
      'description' => 'description',
    }.merge(overrides)
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
    filename = Support.hooks_root.join(hook_name)
    filename.join("run").should be_file
    filename.join("run").should be_executable
    filename.join("meta.yml").should be_file
  end
end
