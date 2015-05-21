require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rspec/core/rake_task"
require "cucumber/rake/task"

Cucumber::Rake::Task.new(:cucumber) do |task|
  task.cucumber_opts = ""
  task.cucumber_opts << "--format pretty"
end

RuboCop::RakeTask.new(:rubocop) do |task|
  # abort rake on failure
  task.fail_on_error = true
end

RSpec::Core::RakeTask.new(:spec)

task pre: ["rubocop:auto_correct", "spec"]

task test: [:rubocop, :spec, :cucumber]

task default: :pre
