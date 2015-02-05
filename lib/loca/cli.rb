require 'loca/git'
require 'loca/url'
require 'loca/exception'
require 'thor'

module Loca
  class CLI < Thor
    include Thor::Actions

    desc 'c URL', 'Check out a pull request locally'
    method_option :delete, aliases: '-d', desc: 'Delete the branch instead of creating it'
    def c(pasted_url)
      return d(pasted_url) if options[:delete]

      git = Loca::Git.new(pasted_url)
      branch_name = git.branch_name

      if git.first_time_creating? || yes?("WARN: Branch '#{branch_name}' "\
        ' already exists. Overwrite? (n)', :yellow)
        git.fetch
        git.checkout
        say "Checked out #{branch_name}!", :green
      else
        fail Loca::GitException, 'Git checkout aborted!'
      end
    end

    desc 'd URL', 'Delete the local branch for that URL'
    def d(pasted_url)
      git = Loca::Git.new(pasted_url)
      branch_name = git.branch_name

      git.delete
      say "Deleted #{branch_name}!", :green
    end
  end
end
