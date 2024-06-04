# frozen_string_literal: true

require "log4r"
require_relative "util/driver"

module VagrantPlugins
  module Tart
    # Provider that is responsible for managing the virtual machine and exposing it to Vagrant.
    class Provider < Vagrant.plugin("2", :provider)
      # The associated driver
      attr_reader :driver

      # Initialize the provider with the given machine.
      def initialize(machine)
        super
        @logger = Log4r::Logger.new("vagrant::provider::tart")
        @machine = machine
        @driver  = Util::Driver.new
      end

      # Check if the provider can be used.
      # rubocop:disable Style/OptionalBooleanParameter
      def self.usable?(raise_error = false)
        raise Errors::MacOSRequired unless Vagrant::Util::Platform.darwin?

        tart_present = Vagrant::Util::Which.which("tart")
        raise Errors::TartRequired unless tart_present

        true
      rescue Errors::TartError
        raise if raise_error

        false
      end
      # rubocop:enable Style/OptionalBooleanParameter

      # Execute the action with the given name.
      def action(name)
        action_method = "action_#{name}"
        return Action.send(action_method) if Action.respond_to?(action_method)

        nil
      end

      # Return the state of the virtual machine.
      def state
        @logger.info("Getting state '#{@machine.id}'")

        state_id = nil
        state_id = :not_created unless @machine.id

        unless state_id
          env = @machine.action(:get_state)
          state_id = env[:machine_state_id]
        end

        # Get the short and long description
        short = state_id.to_s
        long  = ""

        # If we're not created, then specify the special ID flag
        state_id = Vagrant::MachineState::NOT_CREATED_ID if state_id == :not_created

        Vagrant::MachineState.new(state_id, short, long)
      end

      # Return the SSH info for the virtual machine.
      def ssh_info
        # We can only SSH into a running machine
        return nil if state.id != :running

        # Retrieve the IP address
        instance_ip = nil
        begin
          instance_ip = @driver.ip(@machine.provider_config.name)
        rescue Errors::CommandError
          @logger.warn("Failed to read guest IP #{$ERROR_INFO}")
        end

        return nil if instance_ip.nil?

        @logger.info("IP: #{instance_ip}")

        # Return the information
        {
          host: instance_ip,
          port: 22
        }
      end

      def to_s
        id = @machine.id.nil? ? "nil" : @machine.id
        "Tart[#{id}]"
      end
    end
  end
end
