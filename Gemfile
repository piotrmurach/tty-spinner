# frozen_string_literal: true

source "https://rubygems.org"

gemspec

if RUBY_VERSION == "2.0.0"
  gem "json", "2.4.1"
  gem "rake", "12.3.3"
end
gem "pastel", "~> 0.8.0"
gem "yardstick", "~> 0.9.9"

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.7.0")
  gem "coveralls_reborn", "~> 0.28.0"
  gem "simplecov", "~> 0.22.0"
end
