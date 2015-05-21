# Require all runtime dependencies first
require "addressable/uri"
require "colorize"
require "mixlib/shellout"
require "require_all"

# Start by requiring files with no dependencies on other files, then files with
# only external gem runtime dependencies (specified above), then files with
# dependencies on other files within the loca project itself
require_rel "./loca"
