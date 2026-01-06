# frozen_string_literal: true

module VagrantPlugins
  module Tart
    module Model
      # Represents a synced folder for the Tart provider.
      class TartDisk
        # The default tag for auto-mounted folders.
        AUTO_MOUNT ||= "com.apple.virtio-fs.automount" # rubocop:disable Lint/OrAssignmentToConstant
        # The default path for auto-mounted folders on Darwin.
        DARWIN_SHARED_FILES ||= "/Volumes/My Shared Files" # rubocop:disable Lint/OrAssignmentToConstant

        # The path on the host machine.
        attr_accessor :host_path
        # The path on the guest machine.
        attr_accessor :guest_path
        # The mode of the folder (either "ro" or "rw"). Default is "rw".
        attr_accessor :mode
        # The tag of the folder.
        attr_accessor :tag
        # The prefix of the folder.
        attr_accessor :prefix

        # Initialize the folder from configuration data.
        # @param [Hash] data The configuration data.
        def initialize(data)
          @host_path = data[:hostpath]
          @guest_path = data[:guestpath]
          parse_mount_options(data[:mount_options] || [])
        end

        # Check if the disk is auto-mounted.
        def automount?
          @tag == AUTO_MOUNT
        end

        # Convert the disk to a Tart command line option.
        def to_tart_disk
          # Create options
          options = []
          options << "ro" if @mode == "ro"
          options << "tag=#{tag}" if @tag

          result = @host_path.to_s
          if @guest_path.start_with?(DARWIN_SHARED_FILES)
            prefix = @guest_path[DARWIN_SHARED_FILES.length + 1..]
            result = "#{prefix}:#{result}" if prefix
          end
          result += ":#{options.join(",")}" if options.any?
          result
        end

        # Convert the disk to a human readable string.
        def to_s
          "#{@host_path} -> #{@guest_path} (mode=#{@mode || "rw"}, tag=#{@tag || "none"})"
        end

        private

        # Parse the mount options.
        def parse_mount_options(mount_options) # rubocop:disable Metrics/PerceivedComplexity
          # Mode option
          mode = mount_options.find { |option| option.start_with?("mode=") }
                              &.split("=", 2)
                              &.last
          @mode = mode || "rw"

          # Tag option
          tag = mount_options.find { |option| option.start_with?("tag=") }
                             &.split("=", 2)
                             &.last
          @tag = tag || Digest::MD5.hexdigest(@guest_path)
        end
      end
    end
  end
end
