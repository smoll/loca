require "optparse"

module Loca
  class CLI
    def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel)
      @argv = argv
      @stdin = stdin
      @stdout = stdout
      @stderr = stderr
      @kernel = kernel
    end

    def execute!
      begin
        parse_opts
        parse_cmd
      rescue Loca::Error::Standard, OptionParser::InvalidOption => e # colorize if so
        @stderr.puts e.message.red
        @stderr.puts e.backtrace if @options[:backtrace]
        @stdout.puts parser # add if-user-error validation here
        @kernel.exit(1)
      end
      @kernel.exit(0)
    end

    private

    def parse_opts
      parser.parse! @argv
    end

    def parse_cmd
      fail Loca::Error::InvalidURL, "Need to pass in a single URL! Args: #{@argv}" unless @argv.count == 1
      @parsed_url = Loca::URL::Parser.new(@argv[0]).parse

      return delete if @options[:delete]
      return merge if @options[:merge]
      create
    end

    def parser # rubocop:disable Metrics/MethodLength
      return @parser if @parser
      @options = { merge: false, delete: false, backtrace: false }
      @parser = OptionParser.new do |opts|
        opts.banner = "Usage: loca <url> [options]"
        opts.on("-b", "--backtrace", "Display full stacktraces on error") do
          @options[:backtrace] = true
        end
        opts.on("-m", "--merge", "Merges the PR (without a merge bubble!)") do
          @options[:merge] = true
        end
        opts.on("-d", "--delete", "Deletes the checked out branch") do
          @options[:delete] = true
        end
        opts.on_tail("-h", "--help", "Displays help") do
          @stdout.puts opts
          @kernel.exit(0)
        end
        opts.on_tail("-v", "--version", "Display version") do
          @stdout.puts Loca::VERSION
          @kernel.exit(0)
        end
      end
    end

    def merge
      creator = Loca::Git::BranchCreator.new(
        @parsed_url.pull_num,
        @parsed_url.branch_name,
        @parsed_url.remote_name,
        @parsed_url.remote_url
      )
      creator.create

    end

    def delete
      Loca::Git::BranchDeleter.new(@parsed_url.branch_name).delete
      @stdout.puts "Deleted branch #{@parsed_url.branch_name}".green
    end

    def create
      creator = Loca::Git::BranchCreator.new(
        @parsed_url.pull_num,
        @parsed_url.branch_name,
        @parsed_url.remote_name,
        @parsed_url.remote_url
      )
      creator.create
      creator.checkout
      @stdout.puts "Created and checked out branch #{@parsed_url.branch_name}".green
    end
  end
end
