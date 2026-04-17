# frozen_string_literal: true

require "ipaddr"
require "open3"
require "vagrant/action/builtin/mixin_synced_folders"

module VagrantPlugins
  module Tart
    module Action
      # Populates env[:nfs_host_ip] and env[:nfs_machine_ip] so Vagrant's
      # built-in NFS synced folder can mount. Must run between boot and the
      # NFS enable step — the middleware is placed downstream of SyncedFolders
      # so that @app.call returns only after StartInstance + WaitForCommunicator,
      # at which point the guest IP is reachable via ssh_info.
      class PrepareNFSSettings
        include Vagrant::Action::Builtin::MixinSyncedFolders

        def initialize(app, _env)
          @app = app
        end

        def call(env)
          @app.call(env)

          opts = {
            cached: !!env[:synced_folders_cached],
            config: env[:synced_folders_config],
            disable_usable_check: !!env[:test]
          }
          folders = synced_folders(env[:machine], **opts)
          return unless folders.key?(:nfs)

          machine_ip = env[:machine].ssh_info && env[:machine].ssh_info[:host]
          raise Vagrant::Errors::NFSNoGuestIP unless machine_ip

          host_ip = find_host_ip_for(machine_ip)
          raise Vagrant::Errors::NFSNoHostIP unless host_ip

          env[:nfs_host_ip] = host_ip
          env[:nfs_machine_ip] = machine_ip
        end

        # Find the host IPv4 address whose subnet contains the guest IP.
        # Parses `ifconfig` because Socket.getifaddrs returns bogus netmasks
        # on macOS (the host byte is copied into the mask).
        def find_host_ip_for(machine_ip)
          target = IPAddr.new(machine_ip)
          host_ifconfig_inets.each do |addr, netmask_hex|
            next if addr == machine_ip
            mask = hex_netmask_to_dotted(netmask_hex)
            begin
              subnet = IPAddr.new("#{addr}/#{mask}")
            rescue IPAddr::InvalidPrefixError, IPAddr::InvalidAddressError
              next
            end
            return addr if subnet.include?(target)
          end
          nil
        end

        def host_ifconfig_inets
          out, _status = Open3.capture2("ifconfig")
          out.scan(/inet (\d+\.\d+\.\d+\.\d+) netmask (0x[0-9a-fA-F]+)/)
        end

        def hex_netmask_to_dotted(hex)
          n = Integer(hex, 16)
          [(n >> 24) & 0xff, (n >> 16) & 0xff, (n >> 8) & 0xff, n & 0xff].join(".")
        end
      end
    end
  end
end
