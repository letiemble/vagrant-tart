# frozen_string_literal: true

source "https://rubygems.org"

gem "i18n", ">=0.6.4"

group :development do
  gem "rake", "~> 13.0"
  gem "rspec", "~> 3.0"
  gem "rubocop", "~> 1.21"
  gem "rubocop-rspec", "~> 2.0"
  # Use a specific version of Vagrant to ensure compatibility
  gem "vagrant", git: "https://github.com/hashicorp/vagrant.git", tag: "v2.3.5"
end

group :plugins do
  gemspec
end
