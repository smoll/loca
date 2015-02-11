module Loca
  class URL
    attr_reader :branch_name
    attr_reader :pr_num

    def initialize(url)
      @url = url
      ensure_well_formed

      @branch_name = extract_branch_name
      @pr_num = extract_pr_num
    end

    def to_s
      @url
    end

    def ensure_well_formed
      # TODO: add more checks via Addressable::URI
      segments = URI(@url).path.split('/')
      int = Integer(segments[-1]) rescue false # replace with coercible gem?
      pull = segments[-2] == 'pull'

      fail Loca::Error::InvalidURL, "Doesn't appear to be a well-formed URL: #{@url}" unless int && pull
    end

    private

    def extract_branch_name
      "PULL_#{extract_pr_num}"
    end

    def extract_pr_num
      URI(@url).path.split('/').last
    end
  end
end
