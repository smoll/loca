# Using https://raw.githubusercontent.com/bbatsov/rubocop/master/spec/spec_helper.rb as a guide
require 'simplecov'
require 'coveralls'
require 'codeclimate-test-reporter'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter,
  CodeClimate::TestReporter::Formatter
]
SimpleCov.start

require 'bundler/setup'
Bundler.setup # From http://stackoverflow.com/a/4402193

require 'loca'
require 'byebug' # for debugging test code

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

  # From https://raw.githubusercontent.com/erikhuda/thor/master/spec/helper.rb
  # Captures the output for analysis later
  #
  # @example Capture `$stderr`
  #
  #     output = capture(:stderr) { $stderr.puts "this is captured" }
  #
  # @param [Symbol] stream `:stdout` or `:stderr`
  # @yield The block to capture stdout/stderr for.
  # @return [String] The contents of $stdout or $stderr
  # rubocop:disable Lint/Eval
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
  # rubocop:enable Lint/Eval

  # This code was adapted from Ruby on Rails, available under MIT-LICENSE
  # Copyright (c) 2004-2013 David Heinemeier Hansson
  def silence_warnings
    old_verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = old_verbose
  end

  # Silences the output stream
  #
  # @example Silence `$stdout`
  #
  #     silence(:stdout) { $stdout.puts "hi" }
  #
  # @param [IO] stream The stream to use such as $stderr or $stdout
  # @return [nil]
  alias :silence :capture # rubocop:disable Style/Alias
end
