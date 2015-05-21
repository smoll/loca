require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rspec/core/rake_task"

desc "Run RuboCop"
RuboCop::RakeTask.new(:rubocop) do |task|
  # abort rake on failure
  task.fail_on_error = true
end

desc "Run RSpec"
RSpec::Core::RakeTask.new(:spec)

task pre: ["rubocop:auto_correct", "spec"]

task test: [:rubocop, :spec]

task default: :pre
