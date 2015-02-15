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

desc 'Run only unit tests'
RSpec::Core::RakeTask.new(:unit) do |task|
  task.exclude_pattern = 'spec/e2e/**/*_spec.rb'
end

desc 'Run only e2e tests'
RSpec::Core::RakeTask.new(:e2e) do |task|
  task.pattern = 'spec/e2e/**/*_spec.rb'
end

task dev: %w(test install) # lint+test before installing the gem

task test: %w(rubocop spec)

task default: 'test'
