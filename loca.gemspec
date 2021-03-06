# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "loca/version"

Gem::Specification.new do |spec|
  spec.name          = "loca"
  spec.version       = Loca::VERSION
  spec.authors       = ["smoll"]
  spec.email         = ["mollah@gmail.com"]
  spec.summary       = "CLI for checking out GitHub Pull Requests locally"
  spec.homepage      = "https://github.com/smoll/loca"
  spec.license       = "MIT"

  spec.files         = Dir["{bin,lib,spec}/**/*"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "addressable", "~> 2.3"
  spec.add_runtime_dependency "colorize", "~> 0.7"
  spec.add_runtime_dependency "mixlib-shellout", "~> 2.1"
  spec.add_runtime_dependency "require_all", "~> 1.3"

  spec.add_development_dependency "aruba", "~> 0.6"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rspec-its", "~> 1.2"
  spec.add_development_dependency "rubocop", "~> 0.31"
  spec.add_development_dependency "simplecov", "~> 0.10"
end
