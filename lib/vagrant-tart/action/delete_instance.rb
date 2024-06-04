# frozen_string_literal: true

require "i18n"

module VagrantPlugins
  module Tart
    module Action
      # Action block to delete a virtual machine.
      class DeleteInstance
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
          if !instance.nil? && instance.vagrant_state == :stopped
            env[:ui].output(I18n.t("vagrant_tart.messages.deleting_instance", name: name))
            driver.delete(name)
            machine.id = nil
            env[:ui].output(I18n.t("vagrant_tart.messages.instance_deleted", name: name))
          end

          @app.call(env)
        end
      end
    end
  end
end
