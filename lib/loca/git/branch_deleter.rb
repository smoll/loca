module Loca
  module Git
    class BranchDeleter
      include Common
      include Utils

      def initialize(branch)
        @branch = branch
      end

      def delete
        run_git_checkers
        # Cannot delete a branch you are currently on:
        checkout_another_branch if @branch == current_branch
        git "branch -D #{@branch}"
      end

      private

      def checkout_another_branch
        another = "master" if branches.include?("master") # prefer to checkout master branch if it exists
        another = branches.find { |branch| branch != current_branch } unless another
        fail Loca::Error::OnlyOneBranch, "No other branch to checkout!" unless another
        git "checkout #{another}" # prints to stderr for some reason
      end

      def current_branch
        git("rev-parse --abbrev-ref HEAD").strip
      end
    end
  end
end
