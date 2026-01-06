# frozen_string_literal: true

# Check if the Vagrant gem is available
begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant Tart plugin must be run within Vagrant."
end

# Make sure no one is attempting to install this plugin into an early Vagrant version.
raise "The Vagrant Tart plugin is only compatible with Vagrant 2.3 or higher" if Vagrant::VERSION < "2.3.0"

module VagrantPlugins
  module Tart
    # Provides the capabilities to manage Tart virtual machines.
    class Plugin < Vagrant.plugin("2")
      name "tart"
      description "Allows Vagrant to manage Tart virtual machines."

      # Register the configuration.
      config(:tart, :provider) do
        require_relative "config"
        Config
      end

      # Register the provider.
      provider(:tart, box_optional: true, parallel: true) do
        setup_i18n
        require_relative "provider"
        Provider
      end

      # Register the synced folder implementation.
      synced_folder(:tart) do
        require_relative "synced_folder"
        SyncedFolder
      end

      synced_folder_capability(:tart, "mount_options") do
        require_relative "cap/mount_options"
        Cap::MountOptions
      end

      synced_folder_capability(:tart, "mount_type") do
        require_relative "cap/mount_options"
        Cap::MountOptions
      end

      synced_folder_capability(:tart, "mount_name") do
        require_relative "cap/mount_options"
        Cap::MountOptions
      end

      # Register the guest capabilities.
      guest_capability(:darwin, :reboot) do
        require_relative "cap/reboot"
        Cap::Reboot
      end

      # Register the custom VNC command.
      command("vnc", primary: false) do
        require_relative "command/vnc"
        Command::VNC
      end

      # Load the translation files
      def self.setup_i18n
        I18n.load_path << File.expand_path("locales/en.yml", Tart.source_root)
        I18n.reload!
      end
    end
  end
end
