# frozen_string_literal: true

module VagrantPlugins
  module Tart
    module Model
      # Represents the result of a Tart 'list' operation.
      class ListResult
        # @return [Array<ListResultItem>] The list of machines.
        attr_accessor :machines

        # Initialize the result from raw data.
        # @param [Array<Hash>] data The raw data.
        def initialize(data)
          @machines = []
          data.each do |machine|
            item = ListResultItem.new(machine)
            @machines << item
          end
        end

        # Checks if a machine with the given name exists.
        # @param [String] name The name of the machine.
        # @return [Boolean]
        def any?(name)
          @machines.any? { |i| i.name == name }
        end

        # Finds a machine with the given name.
        # @param [String] name The name of the machine.
        # @return [ListResultItem]
        def find(name)
          @machines.find { |i| i.name == name }
        end

        # Represents an item in the list result.
        class ListResultItem
          # @return [Integer] The size of the machine's disk.
          attr_accessor :disk
          # @return [String] The name of the machine.
          attr_accessor :name
          # @return [Boolean] Whether the machine is running.
          attr_accessor :running
          # @return [Integer] The size of the machine's image.
          attr_accessor :size
          # @return [String] The source of the machine (local or oci).
          attr_accessor :source
          # @return [String] The state of the machine.
          attr_accessor :state

          # Initialize the result from raw data.
          # @param [Hash] data The raw data.
          def initialize(data)
            @disk = data["Disk"]
            @name = data["Name"]
            @running = data["Running"]
            @size = data["Size"]
            @source = data["Source"]
            @state = data["State"]
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
end
