module Loca
  module URL
    class Validator
      include Utils

      def initialize(url)
        @url = url
        @uri = Addressable::URI.parse(@url)
        @segments = @uri.path.split("/").reject(&:empty?)
      end

      def validate
        return if valid_host? && valid_user_and_repo_segments? && valid_pull_segment? && valid_pull_number?
        fail Loca::Error::InvalidURL, <<-MSG
          Not a GitHub PR URL: #{@url}
          Examples of valid URLs:
          - https://github.com/smoll/loca/pull/1337
          - https://github.com/smoll/loca/pull/1337/commits
          - https://github.com/smoll/loca/pull/1337/files
        MSG
      end

      private

      def valid_host?
        @uri.host == "github.com"
      end

      def valid_user_and_repo_segments?
        non_empty_string?(@segments[0]) && non_empty_string?(@segments[1])
      end

      def valid_pull_segment?
        @segments[2] == "pull"
      end

      def valid_pull_number?
        Integer(@segments[3])
        true
      rescue ArgumentError
        false
      end
    end
  end
end
