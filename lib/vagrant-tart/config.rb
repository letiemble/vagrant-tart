# frozen_string_literal: true

require "etc"
require "i18n"
require "vagrant"

module VagrantPlugins
  module Tart
    # Holds the configuration for the Tart provider.
    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    class Config < Vagrant.plugin("2", :config)
      # @return [String] The image registry
      attr_accessor :registry
      # @return [String] The image registry username (optional)
      attr_accessor :username
      # @return [String] The image registry password (optional)
      attr_accessor :password

      # @return [String] The image source
      attr_accessor :image
      # @return [String] The name
      attr_accessor :name

      # @return [Boolean] Show a GUI window on boot, or run headless
      attr_accessor :gui
      # @return [Boolean] Whether the audio of the machine passes through the host
      attr_accessor :audio
      # @return [Boolean] Whether the machine and the host share the clipboard
      attr_accessor :clipboard
      # @return [Integer] Number of CPUs
      attr_accessor :cpus
      # @return [Integer] Memory size in MB
      attr_accessor :memory
      # @return [Integer] Disk storage size in GB
      attr_accessor :disk
      # @return [String] Display screen resolution
      attr_accessor :display
      # @return [Boolean] Whether the machine is suspendable
      attr_accessor :suspendable
      # @return [Boolean] Whether the machine expose a VNC server (screen sharing)
      attr_accessor :vnc
      # @return [Boolean] Whether the machine expose a VNC server (virtualization framework)
      attr_accessor :vnc_experimental
      # @return [String] The IP resolver to use (default to 'dhcp')
      attr_accessor :ip_resolver
      # @return [Array<String>] Extra arguments to pass to the tart run command
      attr_accessor :extra_run_args

      # @return [Array<String>] List of volumes to mount
      attr_accessor :volumes

      # Initialize the configuration with unset values
      def initialize
        super

        @registry = UNSET_VALUE
        @username = UNSET_VALUE
        @password = UNSET_VALUE

        @image = UNSET_VALUE
        @name = UNSET_VALUE

        @gui = UNSET_VALUE
        @audio = UNSET_VALUE
        @clipboard = UNSET_VALUE
        @cpus = UNSET_VALUE
        @memory = UNSET_VALUE
        @disk = UNSET_VALUE
        @display = UNSET_VALUE
        @suspendable = UNSET_VALUE
        @vnc = UNSET_VALUE
        @vnc_experimental = UNSET_VALUE
        @ip_resolver = UNSET_VALUE
        @extra_run_args = UNSET_VALUE

        @volumes = []
      end

      # Make sure the configuration has defined all the necessary values
      def finalize!
        @registry = nil if @registry == UNSET_VALUE
        @username = nil if @username == UNSET_VALUE
        @password = nil if @password == UNSET_VALUE

        @image = nil if @image == UNSET_VALUE
        @name = nil if @name == UNSET_VALUE

        @gui = false if @gui == UNSET_VALUE
        @audio = false if @audio == UNSET_VALUE
        @clipboard = false if @clipboard == UNSET_VALUE
        @cpus = 1 if @cpus == UNSET_VALUE
        @memory = 1024 if @memory == UNSET_VALUE
        @disk = 10 if @disk == UNSET_VALUE
        @display = "1024x768" if @display == UNSET_VALUE
        @suspendable = false if @suspendable == UNSET_VALUE
        @vnc = false if @vnc == UNSET_VALUE
        @vnc_experimental = false if @vnc_experimental == UNSET_VALUE
        @ip_resolver = "dhcp" if @ip_resolver == UNSET_VALUE
        @extra_run_args = [] if @extra_run_args == UNSET_VALUE
      end

      # Validate the configuration
      def validate(_machine)
        errors = _detected_errors

        # Sanity checks for the image and the name
        errors << I18n.t("vagrant_tart.config.image_required") if @image.nil? || @image.empty?
        errors << I18n.t("vagrant_tart.config.name_required") if @name.nil? || @name.empty?

        # Check that the GUI flag is a valid boolean
        errors << I18n.t("vagrant_tart.config.gui_invalid") unless @gui == true || @gui == false

        # Check that the audio flag is a valid boolean
        errors << I18n.t("vagrant_tart.config.audio_invalid") unless @audio == true || @audio == false

        # Check that the clipboard flag is a valid boolean
        errors << I18n.t("vagrant_tart.config.clipboard_invalid") unless @clipboard == true || @clipboard == false

        # Check that CPUs is a valid number and between 1 and the maximum available CPUs
        max_cpus = Etc.nprocessors
        unless (@cpus.is_a? Integer) && @cpus >= 1 && @cpus <= max_cpus
          errors << I18n.t("vagrant_tart.config.cpus_invalid", max_cpus: max_cpus)
        end

        # Check that memory is a valid number and between 1 and the maximum available memory
        max_memory = `sysctl -n hw.memsize`.to_i / 1024 / 1024
        unless (@memory.is_a? Integer) && @memory >= 1 && @memory <= max_memory
          errors << I18n.t("vagrant_tart.config.memory_invalid", max_memory: max_memory)
        end

        # Check that disk is a valid number and greater than 1
        errors << I18n.t("vagrant_tart.config.disk_invalid") unless (@disk.is_a? Integer) && @disk >= 1

        # Check that the display resolution is a valid string conforming to the format "WIDTHxHEIGHT"
        errors << I18n.t("vagrant_tart.config.display_invalid") unless @display.match?(/^\d+x\d+$/)

        # Check that the suspendable flag is a valid boolean
        errors << I18n.t("vagrant_tart.config.suspendable_invalid") unless @suspendable == true || @suspendable == false

        # Check that the VNC flag is a valid boolean
        errors << I18n.t("vagrant_tart.config.vnc_invalid") unless @vnc == true || @vnc == false

        # Check that the VNC experimental flag is a valid boolean
        unless @vnc_experimental == true || @vnc_experimental == false
          errors << I18n.t("vagrant_tart.config.vnc_experimental_invalid")
        end

        # Check that the VNC and VNC experimental flags are not both true
        errors << I18n.t("vagrant_tart.config.vnc_exclusive") if @vnc == true && @vnc_experimental == true

        # Check that the IP resolver is a valid string (either 'dhcp', 'arp' or 'agent')
        errors << I18n.t("vagrant_tart.config.ip_resolver_invalid") unless %w[dhcp arp agent].include? @ip_resolver

        # Check that the extra run arguments is an array of strings
        errors << I18n.t("vagrant_tart.config.extra_run_args_invalid") unless @extra_run_args.is_a? Array

        { "Tart Provider" => errors }
      end

      def suspendable?
        @suspendable
      end

      # Check if the configuration uses a registry.
      # @return [Boolean] True if the configuration uses a registry, false otherwise
      def use_registry?
        !@registry.nil?
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  end
end
