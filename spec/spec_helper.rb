# frozen_string_literal: true

require "rspec"
require "simplecov"
require "simplecov-cobertura"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::HTMLFormatter,
                                                                SimpleCov::Formatter::CoberturaFormatter])
SimpleCov.start do
  enable_coverage(:branch)
  # add_group("plugin", "lib")
  add_filter("spec") # Exclude spec files
end

require "vagrant-tart"
require "vagrant-tart/config"
require "vagrant-tart/model/get_result"
require "vagrant-tart/model/list_result"
require "vagrant-tart/model/tart_disk"
require "vagrant-tart/util/driver"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Load the translations
  VagrantPlugins::Tart::Plugin.setup_i18n
end
