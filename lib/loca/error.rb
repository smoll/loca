# Using http://ablogaboutcode.com/2011/01/03/using-custom-error-messages-for-cleaner-code/
# and http://www.simonewebdesign.it/how-to-set-default-message-exception/
module Loca
  module Error
    class Base < StandardError
      def initialize(message)
        # To get the message in red
        $stderr.puts message.red
        @message = message
      end
    end

    InvalidURL = Class.new(Base)

    GitStdErrDetected = Class.new(Base)
    UnstashedFilesFound = Class.new(Base)
    OnlyOneBranch = Class.new(Base)
    RemoteNotSet = Class.new(Base)
    GitAborted = Class.new(Base)
  end
end
