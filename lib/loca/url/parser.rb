module Loca
  module URL
    class Parser
      attr_reader :pull_num, :pull_url, :remote_url, :remote_name, :branch_name

      def initialize(url)
        @url = url
        @uri = Addressable::URI.parse(@url)
        @segments = @uri.path.split("/").reject(&:empty?)
      end

      def to_s
        @url
      end

      def parse
        validate
        parse_attrs
        set_other_attrs
        self
      end

      private

      def validate
        Validator.new(@url).validate
      end

      def parse_attrs
        @username = @segments[0]
        @repo_name = @segments[1]
        @pull_num = @segments[3]

        pull_uri = @uri
        pull_uri.path = @segments[0..3].join("/")
        @pull_url = pull_uri.to_s

        remote_uri = @uri
        remote_uri.path = @segments[0..1].join("/") + ".git"
        @remote_url = remote_uri.to_s
      end

      def set_other_attrs
        @remote_name = "loca_r_#{@username}"
        @branch_name = "PULL_#{@pull_num}"
      end
    end
  end
end
