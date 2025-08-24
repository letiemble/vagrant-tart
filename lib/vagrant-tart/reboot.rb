# frozen_string_literal: true

module Cap
  # This class handles the reboot functionality
  class Reboot
    def self.reboot(machine)
      machine.ui.info("Rebooting the guest machine...")
      machine.communicate.execute("sudo shutdown -r now")
    rescue Vagrant::Errors::VagrantError => e
      machine.ui.error("Failed to reboot: #{e.message}")
    end
  end
end
