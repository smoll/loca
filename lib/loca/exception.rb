require 'colorize'

module Loca
  class Exception < StandardError
    def initialize(message)
      puts message.red
    end
  end

  class GitException < Exception
  end

  class URLException < Exception
  end
end
