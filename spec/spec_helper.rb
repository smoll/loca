# Using https://raw.githubusercontent.com/bbatsov/rubocop/master/spec/spec_helper.rb as a guide
require "simplecov"
require "coveralls"
require "codeclimate-test-reporter"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter,
  CodeClimate::TestReporter::Formatter
]
SimpleCov.start

require "bundler/setup"
Bundler.setup # From http://stackoverflow.com/a/4402193

require "loca"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

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
