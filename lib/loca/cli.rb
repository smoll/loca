require 'git'

require 'byebug' # dev

module Loca
  class CLI
    def initialize(url = 'https://github.com/theorchard/orchard/pull/2411')
      @git = Git.open(Dir.pwd)
      @url = url

      ensure_git_repo
    end

    def echo_url
      puts @url
    end

    def ensure_git_repo
      puts 'remote URLs:'
      @git.remotes.each { |r| puts "#{r.name}: #{r.url}" } # e.g. "upstream: https://github.com/theorchard/orchard.git"
    end
  end
end
