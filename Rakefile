require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rspec/core/rake_task"
require "cucumber/rake/task"
require "coveralls/rake/task"

RuboCop::RakeTask.new(:rubocop) do |task|
  # abort rake on failure
  task.fail_on_error = true
end

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features) do |task|
  task.cucumber_opts = ""
  task.cucumber_opts << "--format pretty"
end

Coveralls::RakeTask.new # task "coveralls:push"

namespace :code_climate do
  task :push do
    require "simplecov"
    require "codeclimate-test-reporter"
    CodeClimate::TestReporter::Formatter.new.format(SimpleCov.result)
  end
end

task pre_commit: ["rubocop:auto_correct", "spec"]

task test: [:rubocop, :spec, :features, "code_climate:push", "coveralls:push"]

task default: :pre_commit
