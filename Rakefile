require 'bundler/gem_tasks'
require 'rubocop/rake_task'

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['**/*.rb', '**/Rakefile']
  # abort rake on failure
  task.fail_on_error = true
end

task dev: %w(rubocop install) # lint before installing the gem

task default: 'rubocop'
