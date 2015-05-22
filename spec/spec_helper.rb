# Using https://raw.githubusercontent.com/bbatsov/rubocop/master/spec/spec_helper.rb as a guide
require "simplecov"
require "codeclimate-test-reporter"

# Sending to Coveralls requires no set up, is done by rake task
# Sending to Code Climate is set up here, but pushed in a rake task
# ref: https://github.com/codeclimate/ruby-test-reporter#using-with-parallel_tests
# ref: https://coveralls.zendesk.com/hc/en-us/articles/201769485-Ruby-Rails
SimpleCov.add_filter "vendor"
SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter]
SimpleCov.start CodeClimate::TestReporter.configuration.profile

require "bundler/setup"
Bundler.setup # From http://stackoverflow.com/a/4402193

require "rspec/its"
require "loca"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.order = :random

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect # Disable `should`
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect # Disable `should_receive` and `stub`
    mocks.verify_partial_doubles = true # Avoid La La Land,
    # read http://wegowise.github.io/blog/2014/09/03/rspec-verifying-doubles/
  end

  config.before do
    ARGV.replace []
  end
end
