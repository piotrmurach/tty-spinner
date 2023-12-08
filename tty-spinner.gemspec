# frozen_string_literal: true

require_relative "lib/tty/spinner/version"

Gem::Specification.new do |spec|
  spec.name          = "tty-spinner"
  spec.version       = TTY::Spinner::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = ["piotr@piotrmurach.com"]
  spec.summary       = %q{A terminal spinner for tasks that have non-deterministic time frame.}
  spec.description   = %q{A terminal spinner for tasks that have non-deterministic time frame.}
  spec.homepage      = "https://ttytoolkit.org"
  spec.license       = "MIT"
  if spec.respond_to?(:metadata=)
    spec.metadata = {
      "allowed_push_host" => "https://rubygems.org",
      "bug_tracker_uri"   => "https://github.com/piotrmurach/tty-spinner/issues",
      "changelog_uri"     => "https://github.com/piotrmurach/tty-spinner/blob/master/CHANGELOG.md",
      "documentation_uri" => "https://www.rubydoc.info/gems/tty-spinner",
      "funding_uri"       => "https://github.com/sponsors/piotrmurach",
      "homepage_uri"      => spec.homepage,
      "rubygems_mfa_required" => "true",
      "source_code_uri"   => "https://github.com/piotrmurach/tty-spinner"
    }
  end
  spec.files         = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.0.0"

  spec.add_dependency "tty-cursor", "~> 0.7"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0"
end
