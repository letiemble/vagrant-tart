# frozen_string_literal: true

require File.expand_path("lib/vagrant-tart/version", __dir__)

Gem::Specification.new do |s|
  s.name        = "vagrant-tart"
  s.version     = VagrantPlugins::Tart.version
  s.authors     = ["Laurent Etiemble"]
  s.email       = ["laurent.etiemble@gmail.com"]
  s.summary     = "Vagrant Tart provider"
  s.description = "Allows Vagrant to manage Tart virtual machines."
  s.homepage    = "https://github.com/letiemble/vagrant-tart"
  s.license     = "MIT"

  s.required_ruby_version = ">= 3.0.0"

  s.metadata["allowed_push_host"] = "https://rubygems.org"
  s.metadata["homepage_uri"] = "https://letiemble.github.io/vagrant-tart"
  s.metadata["source_code_uri"] = "https://github.com/letiemble/vagrant-tart"
  s.metadata["changelog_uri"] = "https://github.com/letiemble/vagrant-tart/blob/main/CHANGELOG.md"
  s.metadata["rubygems_mfa_required"] = "true"

  s.files         = Dir.glob("{lib,locales}/**/*") + %w[LICENSE README.md]
  s.executables   = Dir.glob("bin/*.*").map { |f| File.basename(f) }
  s.require_paths = ["lib"]
end
