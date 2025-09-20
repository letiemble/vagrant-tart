# frozen_string_literal: true

require "i18n"

module VagrantPlugins
  module Tart
    module Cap
      # This class handles the reboot functionality
      class Reboot
        WAIT_SLEEP_TIME = 5

        def self.reboot(machine)
          comm = machine.communicate
          reboot_cmd = "shutdown -r now"

          machine.ui.info(I18n.t("vagrant_tart.messages.restarting_instance", name: machine.name))
          comm.sudo(reboot_cmd)
          sleep(WAIT_SLEEP_TIME)
        rescue Vagrant::Errors::VagrantError => e
          machine.ui.error(I18n.t("vagrant_tart.errors.unable_to_restart_instance", message: e.message))
        end
      end
    end
  end
end
