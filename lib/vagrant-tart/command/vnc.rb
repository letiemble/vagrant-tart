# frozen_string_literal: true

require "i18n"
require "vagrant/util/ansi_escape_code_remover"

module VagrantPlugins
  module Tart
    module Command
      # Command block to open a VNC connection to a virtual machine.
      class VNC < Vagrant.plugin("2", :command)
        def self.synopsis
          "connects to machine via VNC"
        end

        def execute
          options = {}

          opts = OptionParser.new do |o|
            o.banner = "Usage: vagrant vnc [options] [name|id] [-- extra args]"
            o.separator ""
            o.separator "Options:"
            o.separator ""

            o.on("-u", "--username USERNAME", "The username to use for the VNC connection.") do |u|
              options[:username] = u
            end

            o.on("-p", "--password PASSWORD", "The password to use for the VNC connection.") do |p|
              options[:password] = p
            end
          end

          # Parse out the extra args to send to the RDP client, which
          # is everything after the "--"
          split_index = @argv.index("--")
          if split_index
            options[:extra_args] = @argv.drop(split_index + 1)
            @argv                = @argv.take(split_index)
          end

          # Parse the options and return if we don't have any target.
          argv = parse_options(opts)
          return unless argv

          with_target_vms(argv, single_target: true) do |machine|
            vnc_info = get_vnc_info(machine, options)

            machine.ui.detail("Address: #{vnc_info[:host]}") if vnc_info[:host]
            machine.ui.detail("Username: #{vnc_info[:username]}") if vnc_info[:username]

            machine.action(:vnc_connect, vnc_info: vnc_info)
          end

          0
        end

        def get_vnc_info(machine, options = {})
          vnc_info = {}

          ssh_info = machine.ssh_info
          unless ssh_info.nil?
            vnc_info[:host] = ssh_info[:host]
            if options[:username]
              vnc_info[:username] = options[:username]
              vnc_info[:password] = options[:password] || nil
            else
              vnc_info[:username] = ssh_info[:username]
              vnc_info[:password] = ssh_info[:password]
            end
          end
          vnc_info[:extra_args] ||= options[:extra_args]

          vnc_info
        end
      end
    end
  end
end
