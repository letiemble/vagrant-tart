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
      # @return [String] The image registry username
      attr_accessor :username
      # @return [String] The image registry password
      attr_accessor :password

      # @return [String] The image source
      attr_accessor :image
      # @return [String] The name
      attr_accessor :name

      # @return [Integer] Number of CPUs
      attr_accessor :cpus
      # @return [Integer] Memory size in MB
      attr_accessor :memory
      # @return [Integer] Disk storage size in GB
      attr_accessor :disk
      # @return [Boolean] Show a GUI window on boot, or run headless
      attr_accessor :gui
      # @return [String] Display screen resolution
      attr_accessor :display
      # @return [Boolean] Whether the machine is suspendable
      attr_accessor :suspendable

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

        @cpus = UNSET_VALUE
        @memory = UNSET_VALUE
        @disk = UNSET_VALUE
        @gui = UNSET_VALUE
        @display = UNSET_VALUE
        @suspendable = UNSET_VALUE

        @volumes = []
      end

      # Make sure the configuration has defined all the necessary values
      def finalize!
        @registry = nil if @registry == UNSET_VALUE
        @username = nil if @username == UNSET_VALUE
        @password = nil if @password == UNSET_VALUE

        @image = nil if @image == UNSET_VALUE
        @name = nil if @name == UNSET_VALUE

        @cpus = 1 if @cpus == UNSET_VALUE
        @memory = 1024 if @memory == UNSET_VALUE
        @disk = 10 if @disk == UNSET_VALUE
        @gui = false if @gui == UNSET_VALUE
        @display = "1024x768" if @display == UNSET_VALUE
        @suspendable = false if @suspendable == UNSET_VALUE
      end

      # Validate the configuration
      def validate(_machine)
        errors = _detected_errors

        # Sanity checks for the registry
        unless @registry.nil?
          errors << I18n.t("vagrant_tart.config.username_required") if @username.nil? || @username.empty?
          errors << I18n.t("vagrant_tart.config.password_required") if @password.nil? || @password.empty?
        end

        # Sanity checks for the image and the name
        errors << I18n.t("vagrant_tart.config.image_required") if @image.nil? || @image.empty?
        errors << I18n.t("vagrant_tart.config.name_required") if @name.nil? || @name.empty?

        # Check that the GUI flag is a valid boolean
        errors << I18n.t("vagrant_tart.config.gui_invalid") unless @gui == true || @gui == false

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

        { "Tart Provider" => errors }
      end

      def suspendable?
        @suspendable
      end

      def use_registry?
        !@registry.nil? && !@username.nil? && !@password.nil?
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  end
end
