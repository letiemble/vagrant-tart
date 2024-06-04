# frozen_string_literal: true

require "log4r"
require "vagrant/util/platform"
require_relative "model/tart_disk"

module VagrantPlugins
  module Tart
    # Manages the synced folders for the Tart provider.
    class SyncedFolder < Vagrant.plugin("2", :synced_folder)
      def initialize(*args)
        super
        @logger = Log4r::Logger.new("vagrant::provider::tart")
        @disks = []
      end

      # rubocop:disable Style/OptionalBooleanParameter
      def usable?(machine, raise_errors = false)
        # These synced folders only work if the provider if Tart
        if machine.provider_name != :tart
          raise Errors::SyncedFolderNonTart, provider: machine.provider_name.to_s if raise_errors

          return false
        end

        true
      end
      # rubocop:enable Style/OptionalBooleanParameter

      def prepare(machine, folders, _opts)
        @logger.info("Preparing synced folders for Tart provider.")

        # Get the shared folder options
        folders.each_value do |data|
          disk = Model::TartDisk.new(data)
          @disks << disk
        end

        # Add the synced folders to the configuration
        @disks.each do |disk|
          machine.ui.output("Adding disk '#{disk}'.")
          machine.provider_config.volumes << disk.to_tart_disk
        end

        @logger.info("#{@disks.size} synced folders added to the configuration.")
      end

      def enable(machine, _folders, _opts)
        darwin = machine.guest.capability?(:darwin_version)

        @disks.each do |disk|
          enable_disk(machine, disk, darwin)
        end
      end

      def disable(_machine, _folders, _opts)
        # Do nothing
      end

      def cleanup(_machine, _opts)
        @disks.clear
      end

      private

      def enable_disk(machine, disk, darwin)
        machine.ui.output("Mounting disk '#{disk.host_path}' -> '#{disk.guest_path}'...")
        if darwin
          enable_disk_darwin(machine, disk)
        else
          enable_disk_linux(machine, disk)
        end
        machine.ui.success("Disk mounted.")
      end

      def enable_disk_darwin(machine, disk)
        # Create the guest path if it doesn't exist
        machine.communicate.sudo("mkdir -p #{disk.guest_path}") unless disk.automount?

        return if disk.automount? || machine.communicate.test("mount | grep #{disk.guest_path}")

        # Mount the disk
        machine.communicate.sudo("mount_virtiofs #{disk.tag} #{disk.guest_path}")
      end

      def enable_disk_linux(machine, disk)
        # Create the guest path if it doesn't exist
        machine.communicate.sudo("mkdir -p #{disk.guest_path}")

        return if machine.communicate.test("mountpoint -q #{disk.guest_path}")

        # Mount the disk
        machine.communicate.sudo("mount -t virtiofs #{disk.tag} #{disk.guest_path}")
      end
    end
  end
end
