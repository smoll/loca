module Loca
  class Git
    attr_reader :branch_name

    def initialize(url)
      @url = Loca::URL.new(url)
      @branch_name = @url.branch_name

      ensure_git_repo
      @git = ::Git.open(Dir.pwd)
      @remote_name = extract_remote_name
    end

    def delete
      unless branches.include? @branch_name
        fail Loca::GitException, "Not a branch: #{@branch_name}"
      end
      # To avoid Git::GitExecuteError: cannot delete the branch you are on
      # TODO: don't assume 'master' is an available branch
      puts @git.checkout('master')
      puts @git.branch(@branch_name).delete
    end

    def checkout
      @git.branch(@branch_name).checkout
    end

    def fetch
      # To avoid fatal error: Refusing to fetch into current branch
      delete unless first_time_creating?
      # Performs `git fetch upstream pull/PR_NUMBER/head:BRANCH_NAME`
      cmd = "git fetch #{@remote_name} pull/#{@url.pr_num}/head:#{@branch_name}"
      msg = system cmd # TODO: Use ::Git instead of system call
      return if msg
      fail Loca::GitException, "Something went wrong! Try running: `#{cmd}'"
    end

    def first_time_creating? # keep this a public method
      branches.include?(@branch_name) ? false : true
    end

    private

    def branches
      @git.branches.map(&:name)
    end

    def ensure_git_repo
      repo = system 'git rev-parse'
      fail Loca::GitException, "Current directory is not a git repo! pwd: #{Dir.pwd}" unless repo
    end

    def extract_remote_name
      mapping = {}
      @git.remotes.each do |remote|
        # So we get base URLs we can use as the basis for comparison
        mapping[remote.name] = remote.url.sub(/.git$/, '')
      end

      match = mapping.select { |_name, url| @url.to_s.include? url }
      fail Loca::GitException, 'You must set the repo as a remote'\
      " (see `git remote -v'). All remotes: #{mapping}" if match.empty?
      match.keys.first
    end
  end
end
