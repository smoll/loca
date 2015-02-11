module Loca
  class Git
    attr_reader :branch_name

    def initialize(url, remote = nil)
      @url = Loca::URL.new(url)
      @branch_name = @url.branch_name

      ensure_git_repo
      ensure_no_unstashed_files
      @remote_name = remote || extract_remote_name
    end

    def delete
      # Cannot delete a branch you are currently on:
      checkout_another_branch if @branch_name == current_branch
      git "branch -D #{@branch_name}"
    end

    def checkout
      git "checkout #{@branch_name}", false # prints to stderr for some reason
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

    # Example
    #
    # git_match_http?("https://github.com/smoll/loca.git", "https://github.com/smoll/loca/pull/1")
    # => true
    def git_match_http?(git, http)
      format = lambda do |uri| # Strip off uri scheme & trailing '.git'
        uri.sub('https://', '')
        .sub('http://', '')
        .sub('git://', '')
        .sub(/.git$/, '')
      end
      format.call(http).start_with?(format.call(git))
    end

    private

    def git(cmd, fail_on_stderr = true)
      shellout = Mixlib::ShellOut.new "git #{cmd}"
      shellout.run_command
      return shellout.stdout if shellout.stderr.empty?
      if fail_on_stderr
        fail Loca::Error::GitStdErrDetected, "#{shellout.stderr.strip}"
      else
        $stderr.puts shellout.stderr.strip.yellow
      end
      shellout.stdout.strip
    end

    def branches
      git("for-each-ref refs/heads/ --format='%(refname:short)'").split("\n")
    end

    def current_branch
      git('rev-parse --abbrev-ref HEAD').strip
    end

    def ensure_git_repo
      git 'rev-parse'
    end

    def ensure_no_unstashed_files
      val = git 'status --porcelain'
      fail Loca::Error::UnstashedFilesFound, 'Commit or stash your files before continuing!' unless val.empty?
    end

    def checkout_another_branch
      another = branches.find { |branch| branch != current_branch }
      fail Loca::Error::OnlyOneBranch, 'No other branch to checkout!' unless another
      git "checkout #{another}", false # prints to stderr for some reason
    end

    def remote_mapping
      names = git('remote show -n').split("\n")
      mapping = {}
      names.each do |name|
        mapping[name] = git("config --get remote.#{name}.url").strip
      end
      mapping
    end

    def extract_remote_name
      match = remote_mapping.find { |_name, url| git_match_http?(url, @url.to_s) }
      fail Loca::Error::RemoteNotSet, "You must set the repo (#{@url}) as a remote "\
      "(see `git remote -v'). All remotes: #{remote_mapping}" unless match
      match.first
    end
  end
end
