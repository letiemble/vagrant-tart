# frozen_string_literal: true

module VagrantPlugins
  module Tart
    module Model
      # Represents the result of a Tart 'get' operation.
      class GetResult
        # @return [Integer] The number of CPUs of the machine.
        attr_accessor :cpus
        # @return [Integer] The size of the machine's disk.
        attr_accessor :disk
        # @return [Boolean] Whether the machine is running.
        attr_accessor :running
        # @return [Integer] The memory of the machine.
        attr_accessor :memory
        # @return [String] The operating system of the machine.
        attr_accessor :os
        # @return [String] The size of the machine.
        attr_accessor :size
        # @return [String] The state of the machine.
        attr_accessor :state
        # @return [String] The size of the display
        attr_accessor :display

        # Initialize the result from raw data.
        # @param [Hash] data The raw data.
        def initialize(data)
          @cpus = data["CPU"]
          @disk = data["Disk"]
          @running = data["Running"]
          @memory = data["Memory"]
          @os = data["OS"]
          @size = data["Size"]
          @state = data["State"]
          @display = data["Display"]
        end

        # Returns the state of the machine using Vagrant symbols.
        def vagrant_state
          case @state
          when "running"
            :running
          when "stopped", "suspended"
            :stopped
          else
            :host_state_unknown
          end
        end
      end
    end
  end
end
