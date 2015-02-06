# Using http://ablogaboutcode.com/2011/01/03/using-custom-error-messages-for-cleaner-code/
# and http://www.simonewebdesign.it/how-to-set-default-message-exception/
module Loca
  class Exception < StandardError
    def initialize(message)
      # To get the message in red
      $stderr.puts message.red
      @message = message
    end
  end

  class GitException < Exception
  end

  class URLException < Exception
  end
end
