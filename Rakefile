require 'bundler'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) { |t| t.verbose = false }
Bundler::GemHelper.install_tasks
task default: :spec
