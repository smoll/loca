# Require all runtime dependencies first
require 'thor'
require 'colorize'
require 'git'

# Start by requiring files with no dependencies on other files, then files with
# only external gem runtime dependencies (specified above), then files with
# dependencies on other files within the loca project itself
require 'loca/version'
require 'loca/exception'
require 'loca/url'
require 'loca/git'
require 'loca/cli'