require 'mixlib/shellout'
require 'fileutils'

module Features
  module GitHubHelper
    def teardown
      return_to_original_wd
      FileUtils.rm_rf absolute_path
    end

    def cd_to_cloned_dir
      @original_wd = Dir.pwd
      Dir.chdir(absolute_path)
    end

    def return_to_original_wd
      Dir.chdir(@original_wd)
    end

    def clone_test_repo
      shellout! "git clone https://github.com/smoll/Spoon-Knife ./#{rel_path}"
    end

    def set_upstream
      shellout! 'git remote add upstream https://github.com/octocat/Spoon-Knife.git'
    end

    def current_branch
      shellout! 'git rev-parse --abbrev-ref HEAD'
    end

    def shellout!(cmd, opts = {})
      opts = {
        input: nil
      }.merge(opts)
      sh = opts[:input].nil? ? Mixlib::ShellOut.new(cmd.to_s) : Mixlib::ShellOut.new(cmd.to_s, input: opts[:input].to_s)
      sh.run_command

      sh.error! if opts[:input].nil? # NOTE: CLI exits non-zero if waiting on user input
      sh.stdout
    end

    private

    def rel_path
      absolute_path.split(Dir.pwd.to_s)[1].sub('/', '')
    end

    def absolute_path
      path = File.expand_path('../../../tmp/cloned', __FILE__)
      FileUtils.mkdir_p path
      path
    end
  end
end