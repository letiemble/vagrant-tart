# frozen_string_literal: true

require "vagrant-tart"
require "vagrant-tart/config"
require "vagrant-tart/model/get_result"
require "vagrant-tart/model/list_result"
require "vagrant-tart/model/tart_disk"
require "vagrant-tart/util/driver"

EXISTING_NAME = "existing_name"
MISSING_NAME = "missing_name"
NEW_NAME = "new_name"

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
