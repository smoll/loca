# Using http://ablogaboutcode.com/2011/01/03/using-custom-error-messages-for-cleaner-code/
# and http://www.simonewebdesign.it/how-to-set-default-message-exception/
module Loca
  module Error
    class Standard < StandardError; end

    InvalidURL = Class.new(Standard)
    GitStdErrDetected = Class.new(Standard)
    UnstashedFilesFound = Class.new(Standard)
    OnlyOneBranch = Class.new(Standard)
    RemoteNotSet = Class.new(Standard)
    GitAborted = Class.new(Standard)
  end
end
