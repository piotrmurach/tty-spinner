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
  spec.homepage      = "https://piotrmurach.github.io/tty"
  spec.license       = 'MIT'

  spec.files         = Dir['{lib,spec,examples}/**/*.rb']
  spec.files        += Dir['{bin,tasks}/*', 'tty-spinner.gemspec']
  spec.files        += Dir['README.md', 'CHANGELOG.md', 'LICENSE.txt', 'Rakefile']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency 'tty-cursor', '~> 0.7'

  spec.add_development_dependency 'bundler', '>= 1.5.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rake'
end
