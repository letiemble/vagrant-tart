# frozen_string_literal: true

require "vagrant"
require "vagrant/action/builder"

module VagrantPlugins
  module Tart
    # Contains all the supported actions of the Tart provider.
    module Action
      # Include the built-in Vagrant action modules
      include Vagrant::Action::Builtin

      # Autoloading action blocks
      action_root = Pathname.new(File.expand_path("action", __dir__))
      autoload :CreateInstance, action_root.join("create_instance")
      autoload :DeleteInstance, action_root.join("delete_instance")
      autoload :ForwardPorts, action_root.join("forward_ports")
      autoload :GetState, action_root.join("get_state")
      autoload :Login, action_root.join("login")
      autoload :PullImage, action_root.join("pull_image")
      autoload :StartInstance, action_root.join("start_instance")
      autoload :StopInstance, action_root.join("stop_instance")
      autoload :SuspendInstance, action_root.join("suspend_instance")
      autoload :VNCConnect, action_root.join("vnc_connect")
      autoload :MessageWillNotDestroy, action_root.join("message_will_not_destroy")

      # Vagrant action "destroy".
      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate

          b.use Call, IsState, :not_created do |env1, b1|
            raise Errors::InstanceNotCreatedError if env1[:result]

            b1.use Call, DestroyConfirm do |env2, b2|
              if env2[:result]
                b2.use ProvisionerCleanup, :before
                b2.use StopInstance
                b2.use DeleteInstance
                b2.use SyncedFolderCleanup
              else
                b2.use MessageWillNotDestroy
              end
            end
          end
        end
      end

      # Vagrant action "halt".
      def self.action_halt
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate

          b.use Call, IsState, :not_created do |env, b1|
            raise Errors::InstanceNotCreatedError if env[:result]

            b1.use StopInstance
          end
        end
      end

      # Vagrant action "provision".
      def self.action_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate

          b.use Call, IsState, :not_created do |env, b1|
            raise Errors::InstanceNotCreatedError if env[:result]

            b1.use Provision
          end
        end
      end

      # Vagrant action "reload".
      def self.action_reload
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate

          b.use Call, IsState, :not_created do |env, b1|
            raise Errors::InstanceNotCreatedError if env[:result]

            b1.use action_halt
            b1.use action_start
          end
        end
      end

      # Vagrant action "resume".
      def self.action_resume
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate

          b.use Call, IsState, :not_created do |env, b1|
            raise Errors::InstanceNotCreatedError if env[:result]

            b1.use action_start
          end
        end
      end

      # Vagrant action "ssh".
      def self.action_ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate

          b.use Call, IsState, :not_created do |env, b1|
            raise Errors::InstanceNotCreatedError if env[:result]

            b1.use Call, IsState, :running do |env2, b2|
              raise Errors::InstanceNotRunningError unless env2[:result]

              b2.use SSHExec
            end
          end
        end
      end

      # Vagrant action "ssh_run".
      def self.action_ssh_run
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate

          b.use Call, IsState, :not_created do |env, b1|
            raise Errors::InstanceNotCreatedError if env[:result]

            b1.use Call, IsState, :running do |env2, b2|
              raise Errors::InstanceNotRunningError unless env2[:result]

              b2.use SSHRun
            end
          end
        end
      end

      # Vagrant action "suspend".
      def self.action_suspend
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate

          b.use Call, IsState, :not_created do |env, b1|
            raise Errors::InstanceNotCreatedError if env[:result]

            b1.use Call, IsState, :running do |env2, b2|
              raise Errors::InstanceNotRunningError unless env2[:result]

              b2.use SuspendInstance
            end
          end
        end
      end

      # Vagrant action "up".
      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate

          b.use Login
          b.use PullImage
          b.use CreateInstance

          b.use action_start
        end
      end

      # Vagrant action "vnc_connect".
      def self.action_vnc_connect
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate

          b.use Call, IsState, :not_created do |env, b1|
            raise Errors::InstanceNotCreatedError if env[:result]

            b1.use Call, IsState, :running do |env2, b2|
              raise Errors::InstanceNotRunningError unless env2[:result]

              b2.use VNCConnect
            end
          end
        end
      end

      # Retrieves the state of the virtual machine.
      def self.action_get_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use GetState
        end
      end

      # Starts the virtual machine.
      def self.action_start
        Vagrant::Action::Builder.new.tap do |b|
          b.use Provision
          b.use SyncedFolderCleanup
          b.use SyncedFolders
          b.use SetHostname
          b.use StartInstance
          b.use WaitForCommunicator
        end
      end
    end
  end
end
