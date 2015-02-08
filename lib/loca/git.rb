module Loca
  class Git
    attr_reader :branch_name

    def initialize(url, remote = nil)
      @url = Loca::URL.new(url)
      @branch_name = @url.branch_name

      ensure_git_repo
      ensure_no_unstashed_files
      @git = ::Git.open(Dir.pwd)
      @remote_name = remote || extract_remote_name
    end

    def delete
      unless branches.include? @branch_name
        fail Loca::GitException, "Not a branch: #{@branch_name}"
      end
      # Cannot delete a branch you are currently on:
      checkout_another_branch if @branch_name == current_branch
      git "branch -D #{@branch_name}"
    end

    def checkout
      @git.branch(@branch_name).checkout
    end

    def fetch
      # To avoid fatal error: Refusing to fetch into current branch
      delete unless first_time_creating?
      # Performs `git fetch upstream pull/PR_NUMBER/head:BRANCH_NAME`
      git "fetch #{@remote_name} pull/#{@url.pr_num}/head:#{@branch_name}", false # shellout has stderr for some reason
    end

    def first_time_creating? # Keep this a public method so we can prompt the user for overwrite
      branches.include?(@branch_name) ? false : true
    end

    private

    def git(cmd, fail_on_stderr = true)
      shellout = Mixlib::ShellOut.new "git #{cmd}"
      shellout.run_command
      return shellout.stdout if shellout.stderr.empty?
      if fail_on_stderr
        fail Loca::GitException, "#{shellout.stderr}"
      else
        puts shellout.stderr.red
      end
      shellout.stdout
    end

    def branches
      @git.branches.map(&:name)
    end

    def current_branch
      git 'rev-parse --abbrev-ref HEAD'
    end

    def ensure_git_repo
      git 'rev-parse'
    end

    def ensure_no_unstashed_files
      val = git 'status --porcelain'
      fail Loca::GitException, 'Commit or stash your files before continuing!' unless val.empty?
    end

    def checkout_another_branch
      puts "branches: #{branches}".yellow
      another = branches.find { |branch| branch != current_branch }
      puts "another: #{another}".yellow
      @git.branch(another).checkout
    end

    def extract_remote_name
      mapping = {}
      @git.remotes.each do |remote|
        mapping[remote.name] = remote.url.sub(/.git$/, '') # Strip off trailing '.git'
      end

      match = mapping.select { |_name, url| @url.to_s.include? url }
      fail Loca::GitException, 'You must set the repo as a remote '\
      "(see `git remote -v'). All remotes: #{mapping}" if match.empty?
      match.keys.first
    end
  end
end
