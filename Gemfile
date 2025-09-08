# frozen_string_literal: true

source "https://rubygems.org"

gem "i18n", ">=0.6.4"

group :development do
  gem "bump", "~> 0.10"
  gem "rake", "~> 13.0"
  gem "rspec", "~> 3.13"
  gem "rubocop", "~> 1.68"
  gem "rubocop-rspec", "~> 3.2"
  gem "simplecov", "~> 0.22"
  gem "simplecov-cobertura", "~> 3.1"
  # Use a specific version of Vagrant to ensure compatibility
  gem "vagrant", git: "https://github.com/hashicorp/vagrant.git", tag: "v2.3.5"
end

group :plugins do
  gemspec
end
