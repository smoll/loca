# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'loca/version'

Gem::Specification.new do |spec|
  spec.name          = 'loca'
  spec.version       = Loca::VERSION
  spec.authors       = ['smoll']
  spec.email         = ['mollah@gmail.com']
  spec.summary       = 'CLI for checking out GitHub Pull Requests locally'
  spec.homepage      = 'https://github.com/smoll/loca'
  spec.license       = 'MIT'

  spec.files         = Dir['{bin,lib,spec}/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'git', '~> 1.2', '>= 1.2.9.1'
  spec.add_runtime_dependency 'thor', '~> 0.19.1'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'byebug', '~> 0'
end
