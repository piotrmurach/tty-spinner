# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tty/spinner/version'

Gem::Specification.new do |spec|
  spec.name          = 'tty-spinner'
  spec.version       = TTY::Spinner::VERSION
  spec.authors       = ['Piotr Murach']
  spec.email         = ['pmurach@gmail.com']
  spec.summary       = %q{A terminal spinner for tasks that have non-deterministic time frame.}
  spec.description   = %q{A terminal spinner for tasks that have non-deterministic time frame.}
  spec.homepage      = 'https://github.com/peter-murach/tty-spinner'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb', 'LICENSE.txt', 'README.md']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1.5.0', '< 2.0'
  spec.add_development_dependency 'rake'
end
