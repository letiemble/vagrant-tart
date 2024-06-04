# frozen_string_literal: true

require "i18n"

module VagrantPlugins
  module Tart
    module Action
      # Action block to suspend a virtual machine.
      class SuspendInstance
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          machine = env[:machine]
          config = machine.provider_config
          driver = machine.provider.driver
          name = config.name
          suspendable = config.suspendable?

          list = driver.list
          return @app.call(env) unless list.any?(name)

          instance = driver.get(name)
          return @app.call(env) if instance.nil? || !suspendable

          env[:ui].output(I18n.t("vagrant_tart.messages.suspending_instance", name: name))
          driver.suspend(name)
          env[:ui].output(I18n.t("vagrant_tart.messages.instance_suspended", name: name))

          @app.call(env)
        end
      end
    end
  end
end
