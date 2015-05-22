require "simplecov"
require "aruba/cucumber"

SimpleCov.command_name "features"

Before do
  run_simple "rake install" # install gem
  run_simple "git clone https://github.com/smoll/Spoon-Knife spoony" # clone repo used by features
  cd "spoony"
  set_env("COVERAGE", "true") # see /bin/loca
end
