# frozen_string_literal: true

module VagrantPlugins
  module Tart
    module Errors
      # The base class for all plugin errors.
      class TartError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_tart.errors")
      end

      # This error is raised if the platform is not MacOS.
      class MacOSRequired < TartError
        error_key(:macos_required)
      end

      # This error is raised if the Tart binary is not found.
      class TartRequired < TartError
        error_key(:tart_required)
      end

      # This error is raised if a Tart command fails.
      class CommandError < TartError
        error_key(:command_error)
      end

      # This error is raised if the virutal machine is not created.
      class InstanceNotCreatedError < TartError
        error_key(:instance_not_created)
      end

      # This error is raised if the virtual machine is not running.
      class InstanceNotRunningError < TartError
        error_key(:instance_not_running)
      end

      # This error is raised if the synced folder are not for Tart.
      class SyncedFolderNonTart < TartError
        error_key(:synced_folder_not_tart)
      end
    end
  end
end
