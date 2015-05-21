module Loca
  module Git
    module Common
      def run_git_checkers
        ensure_git_repo
        ensure_no_unstashed_files
      end

      def git(cmd)
        shellout = Mixlib::ShellOut.new "git #{cmd}"
        shellout.run_command
        shellout.error!
        shellout.stdout
      end

      def branches
        git("for-each-ref refs/heads/ --format='%(refname:short)'").split("\n")
      end

      # Example
      #
      # git_urls_match?("https://github.com/smoll/loca.git", "https://github.com/smoll/loca/") # note trailing slash
      # => true
      def git_urls_match?(git, http)
        git_uri = Addressable::URI.parse git
        http_uri = Addressable::URI.parse http
        http_uri.host == git_uri.host && http_uri.path.chomp("/").chomp(".git") == git_uri.path.chomp("/").chomp(".git")
      end

      private

      def ensure_git_repo
        git "rev-parse"
      end

      def ensure_no_unstashed_files
        val = git "status --porcelain"
        fail Loca::Error::UnstashedFilesFound, "Commit or stash your files before continuing!" if non_empty_string?(val)
      end
    end
  end
end
