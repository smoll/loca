require 'git' # gem
require 'uri'

module Loca
  class Git
    def initialize(url)
      @url = url
      @git = ::Git.open(Dir.pwd)
    end

    def perform_git_checks
      # not sure if we need to explicitly check whether Dir.pwd is a git repository
      ensure_git_repo
      ensure_well_formed_url
    end

    def extract_branch_name
      num = URI(@url).path.split('/').last
      "PULL_#{num}"
    end

    def already_checked_out?(name = nil) # keep this a public method
      name ||= extract_branch_name
      match = @git.branches.find { |branch| branch.name == name }
      match.nil? ? false : true
    end

    private

    def ensure_git_repo
      mapping = {}
      @git.remotes.each do |remote|
        mapping[remote.name] = remote.url.sub(/.git$/, '') # strip off trailing '.git'
      end

      match = mapping.select { |_name, url| @url.include? url }
      fail "You must set the repo as a remote (see `git remote -v'). All remotes: #{mapping}" unless match
    end

    def ensure_well_formed_url
      segments = URI(@url).path.split('/')
      int = Integer(segments[-1]) rescue false # replace with coercible gem?
      pull = segments[-2] == 'pull'

      fail "Doesn't appear to be a well-formed URL: #{@url}" unless int && pull
    end
  end
end
