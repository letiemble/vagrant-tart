# frozen_string_literal: true

require "i18n"

module VagrantPlugins
  module Tart
    module Action
      # Action block to stop a virtual machine.
      class StopInstance
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

          env[:ui].output(I18n.t("vagrant_tart.messages.stopping_instance", name: name))
          driver.stop(name)
          env[:ui].output(I18n.t("vagrant_tart.messages.instance_stopped", name: name))

          @app.call(env)
        end
      end
    end
  end
end
