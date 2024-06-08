# frozen_string_literal: true

require "i18n"

module VagrantPlugins
  module Tart
    module Action
      # Action block to start a virtual machine.
      class StartInstance
        def initialize(app, _env)
          @app = app
        end

        # rubocop:disable Metrics/AbcSize
        def call(env)
          machine = env[:machine]
          config = machine.provider_config
          driver = machine.provider.driver
          name = config.name

          list = driver.list
          return @app.call(env) unless list.any?(name)

          instance = driver.get(name)
          return @app.call(env) if instance.nil? || instance.vagrant_state == :running

          env[:ui].output(I18n.t("vagrant_tart.messages.configuring_instance", name: name))
          driver.set(name, "cpus", config.cpus)
          driver.set(name, "memory", config.memory)
          driver.set(name, "disk", config.disk)
          driver.set(name, "display", config.display)
          env[:ui].output(I18n.t("vagrant_tart.messages.instance_configured", name: name))

          env[:ui].output(I18n.t("vagrant_tart.messages.starting_instance", name: name))
          driver.run(name, config.gui, config.suspendable?, config.volumes)
          env[:ui].output(I18n.t("vagrant_tart.messages.instance_started", name: name))

          @app.call(env)
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
