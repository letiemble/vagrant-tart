# frozen_string_literal: true

require "i18n"

module VagrantPlugins
  module Tart
    module Action
      # Action block to connect to the VNC server exposed by the VM.
      class VNCConnect
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          machine = env[:machine]
          config = machine.provider_config
          driver = machine.provider.driver
          name = config.name

          list = driver.list
          return @app.call(env) unless list.any?(name)

          instance = driver.get(name)
          return @app.call(env) if instance.nil? || instance.vagrant_state != :running

          # Grab the VNC info from the machine or the environment
          info = env[:vnc_info]
          info ||= env[:machine].ssh_info

          env[:ui].output(I18n.t("vagrant_tart.messages.connecting_to_vnc", name: name))
          driver.vnc_connect(info)

          @app.call(env)
        end
      end
    end
  end
end
