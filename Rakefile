require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['**/*.rb', '**/Rakefile']
  task.options = [
    '--display-cop-names'
  ]
  # abort rake on failure
  task.fail_on_error = true
end

desc 'Run RSpec'
RSpec::Core::RakeTask.new(:spec)

task dev: %w(test install) # lint+test before installing the gem

task test: %w(rubocop spec)

task default: 'test'
