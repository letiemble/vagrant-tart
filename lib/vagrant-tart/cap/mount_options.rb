# frozen_string_literal: true

# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: BUSL-1.1

require_relative "../util/unix_mount_helpers"

module VagrantPlugins
  module Tart
    module Cap
      # Capability for mount options
      module MountOptions
        extend Vagrant::Util::GuestInspection::Linux
        extend VagrantPlugins::SyncedFolder::UnixMountHelpers

        # Mount type for VirtFS
        TART_MOUNT_TYPE = "virtiofs"

        # Returns mount options for a utm synced folder
        #
        # @param [Machine] machine
        # @param [String] name of mount
        # @param [String] path of mount on guest
        # @param [Hash] hash of mount options
        def self.mount_options(machine, _name, guest_path, options)
          comm = machine.communicate
          mount_options = options.fetch(:mount_options, [])
          detected_ids = detect_owner_group_ids(machine, guest_path, mount_options, options)
          mount_uid = detected_ids[:uid]
          mount_gid = detected_ids[:gid]

          # Remove non-filesystem related mount options
          mount_options = mount_options.reject { |opt| opt.include?("tag=") || opt.include?("mode=") }

          # virtiofs mount options

          # For operating systems using systemd, we need to specify automounting
          # and running prior-to remove filesystems being mounted
          # This mimics the behaviour of _netdev in standard systems
          if systemd?(comm)
            mount_options << "x-systemd.automount"
            mount_options << "x-systemd.before=remote-fs.target"
          else
            mount_options << "_netdev"
          end

          mount_options << "nofail"

          mount_options = mount_options.join(",")
          [mount_options, mount_uid, mount_gid]
        end

        def self.mount_type(_machine)
          TART_MOUNT_TYPE
        end

        def self.mount_name(_machine, name, data)
          mount_options = data.fetch(:mount_options, [])

          tag = mount_options.find { |option| option.start_with?("tag=") }
                             &.split("=", 2)
                             &.last

          tag || Digest::MD5.hexdigest(name)
        end
      end
    end
  end
end
