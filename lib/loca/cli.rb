require 'loca/git'
require 'thor'

require 'byebug' # dev

module Loca
  class CLI < Thor
    include Thor::Actions

    desc 'checkout', 'Check out a pull request locally'
    def checkout(url)
      branch = perform_checks(url)
      say "Begin checkout of #{branch}!", :green # TODO: should call a Loca::Git inst method
    end

    private

    def perform_checks(url)
      git = Loca::Git.new(url)
      git.perform_git_checks

      branch_name = git.extract_branch_name

      return branch_name unless git.already_checked_out? branch_name
      if yes?("WARN: Branch '#{branch_name}' is already checked out. Overwrite? (n)", :yellow)
        return branch_name
      else
        fail 'Git checkout aborted!'
      end
    end
  end
end
