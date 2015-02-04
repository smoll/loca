require 'bundler/gem_tasks'

task dev: ['build'] do
  gem_file = Dir.glob('./pkg/loca-*.gem').sort.last
  system "gem install #{gem_file}" # installs runtime dependencies too
end
