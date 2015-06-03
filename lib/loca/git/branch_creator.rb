module Loca
  module Git
    class BranchCreator
      include Common
      include Utils

      def initialize(pull_num, branch_name, remote_name, remote_url)
        @pull_num = pull_num
        @branch_name = branch_name
        @remote_name = remote_name
        @remote_url = remote_url
      end

      def create
        run_git_checkers
        add_remote
        # To avoid fatal error: Refusing to fetch into current branch
        delete unless first_time_creating?
        fetch
      end

      def checkout
        git "checkout #{@branch_name}" # prints to stderr for some reason
      end

      def merge
        git "checkout master"
        git "merge #{@branch_name}"
      end

      private

      def fetch
        # Performs `git fetch upstream pull/PR_NUMBER/head:BRANCH_NAME`
        git "fetch #{@remote_name} pull/#{@pull_num}/head:#{@branch_name}" # shellout has stderr for some reason
      end

      def delete
        BranchDeleter.new(@branch_name).delete
      end

      def first_time_creating?
        branches.include?(@branch_name) ? false : true
      end

      def remote_mapping
        names = git("remote show -n").split("\n")
        mapping = {}
        names.each do |name|
          mapping[name] = git("config --get remote.#{name}.url").strip
        end
        mapping
      end

      def add_remote
        match = remote_mapping.find { |_name, url| git_urls_match?(url, @remote_url) }
        return @remote_name = match.first if match # avoid creating duplicate remotes
        git "remote add #{@remote_name} #{@remote_url}"
      end
    end
  end
end
