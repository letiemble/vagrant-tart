# frozen_string_literal: true

require "pathname"
require "vagrant/util/busy"
require "vagrant/util/subprocess"
require_relative "../model/get_result"
require_relative "../model/list_result"

module VagrantPlugins
  module Tart
    module Util
      # Executes commands on the host machine through the Tart command line interface.
      # rubocop:disable Metrics/ClassLength
      class Driver
        # Initialize the driver with the path to the scripts directory.
        def initialize
          @script_path = Pathname.new(File.expand_path("../scripts", __dir__))
        end

        # Execute the 'clone' command.
        # @param source [String] The source image
        # @param name [String] The name of the machine
        # @yield [(String, String)] The output of the command
        def clone(source, name, &block)
          cmd = ["tart", "clone", source, name]
          execute(*cmd, &block)
        end

        # Trigger a VNC connection to the machine.
        # @param info [Hash] The information to connect to the machine
        def vnc_connect(info)
          machine_ip = info[:host]
          username = info[:username]
          password = info[:password]

          auth = if username && password
                   "#{username}:#{password}@"
                 elsif username
                   "#{username}@"
                 else
                   ""
                 end
          target = "vnc://#{auth}#{machine_ip}"

          script_path = @script_path.join("open.sh")
          cmd = [script_path.to_s, target]
          execute(*cmd)
        end

        # Execute the 'create' command.
        # @param name [String] The name of the machine
        def delete(name)
          cmd = ["tart", "delete", name]
          execute(*cmd)
        end

        # Execute the 'get' command and returns the machine detailed information.
        # @param name [String] The name of the machine
        # @return [VagrantPlugins::Tart::Model::GetResult] The result of the command
        def get(name)
          cmd = ["tart", "get", name, "--format", "json"]
          result = execute(*cmd)
          data = JSON.parse(result)
          Model::GetResult.new(data)
        end

        # Execute the 'ip' commanda and returns the IP address of the machine.
        # @param name [String] The name of the machine
        # @return [String] The IP address of the machine
        def ip(name)
          cmd = ["tart", "ip", name]
          result = execute(*cmd)
          result.strip
        end

        # Execute the 'list' command and returns the list of machines.
        # @return [VagrantPlugins::Tart::Model::ListResult] The result of the command
        def list
          cmd = ["tart", "list", "--format", "json"]
          result = execute(*cmd)
          data = JSON.parse(result)
          Model::ListResult.new(data)
        end

        # Execute the 'login' command by calling an accessory script.
        # @param host [String] The registry host name
        # @param username [String] The username
        # @param password [String] The password
        def login(host, username, password)
          script_path = @script_path.join("login.sh")
          cmd = [script_path.to_s, host, username, password]
          execute(*cmd)
        end

        # Execute the 'logout' command.
        # @param host [String] The registry host name
        def logout(host)
          cmd = ["tart", "logout", host]
          execute(*cmd)
        end

        # Execute the 'pull' command.
        # @param image [String] The image to pull
        # @yield [(String, String)] The output of the command
        def pull(image, &block)
          cmd = ["tart", "pull", image]
          execute(*cmd, &block)
        end

        # Execute the 'run' command by calling an accessory script.
        # @param name [String] The name of the machine
        # @param options [Hash] The options to pass to the command
        # @param options.use_gui [Boolean] Whether to use the GUI
        # @param options.suspend [Boolean] Whether the machine is suspendable
        # @param options.volumes [Array<String>] The volumes to mount
        def run(name, config)
          script_path = @script_path.join("run.sh")

          cmd = [script_path.to_s, name]
          cmd << "--no-graphics" unless config.gui
          cmd << "--suspendable" if config.suspendable?
          cmd << "--vnc" if config.vnc
          cmd << "--vnc-experimental" if config.vnc_experimental

          config.volumes.each do |volume|
            cmd << "--dir=#{volume}"
          end

          execute(*cmd)
        end

        # Execute the 'stop' command.
        # @param name [String] The name of the machine
        # @param timeout [Integer] The timeout in seconds
        def stop(name, timeout = nil)
          cmd = ["tart", "stop", name]
          cmd << ["--timeout", timeout.to_s] if timeout&.positive?
          execute(*cmd)
        end

        # Execute the 'suspend' command.
        # @param name [String] The name of the machine
        def suspend(name)
          cmd = ["tart", "suspend", name]
          execute(*cmd)
        end

        # Execute the 'set' command.
        # @param name [String] The name of the machine
        # @param key [String] The key to set
        # @param value [String] The value to set
        def set(name, key, value)
          return if value == Config::UNSET_VALUE

          # Map the key to the correct switch
          switch = nil
          case key
          when "cpus"
            switch = "--cpu"
          when "memory"
            switch = "--memory"
          when "display"
            switch = "--display"
          when "disk"
            switch = "--disk-size"
          end
          return unless switch

          cmd = ["tart", "set", name, switch, value.to_s]
          execute(*cmd)
        end

        # Execute the 'version' command and returns the version of Tart.
        # @return [String] The version of Tart
        def version
          cmd = ["tart", "--version"]
          result = execute(*cmd)
          result.strip
        end

        private

        # Execute a command on the host machine.
        # Heavily inspired from https://github.com/hashicorp/vagrant/blob/main/plugins/providers/docker/executor/local.rb.
        def execute(*cmd, &block)
          # Append in the options for subprocess
          cmd << { notify: %i[stdout stderr] }

          interrupted  = false
          int_callback = -> { interrupted = true }
          result = ::Vagrant::Util::Busy.busy(int_callback) do
            ::Vagrant::Util::Subprocess.execute(*cmd, &block)
          end

          # Trim the outputs
          result.stderr.gsub!("\r\n", "\n")
          result.stdout.gsub!("\r\n", "\n")

          if result.exit_code != 0 && !interrupted
            raise VagrantPlugins::Tart::Errors::CommandError,
                  command: cmd.inspect,
                  stderr: result.stderr,
                  stdout: result.stdout
          end

          # Return the outputs of the command
          "#{result.stdout} #{result.stderr}"
        end
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
