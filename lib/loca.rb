require 'loca/version'

module Loca
  class CLI
    def initialize(url = 'https://github.com/theorchard/orchard/pull/2411')
      @url = url
    end

    def echo_url
      puts @url
    end
  end
end
