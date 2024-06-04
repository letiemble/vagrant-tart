# frozen_string_literal: true

require "i18n"

module VagrantPlugins
  module Tart
    module Action
      # Action to check if Tart is present and can be invoked.
      class Login
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          machine = env[:machine]
          config = machine.provider_config
          driver = machine.provider.driver

          return @app.call(env) unless config.use_registry?

          login(env, config, driver)
        end

        private

        def login(env, config, driver)
          # Login to the registry
          env[:ui].output(I18n.t("vagrant_tart.messages.logging_in"))
          driver.login(config.registry, config.username, config.password)
          env[:ui].output(I18n.t("vagrant_tart.messages.logged_in"))

          # Continue with the middleware stack
          @app.call(env)

          # Logout from the registry
          env[:ui].output(I18n.t("vagrant_tart.messages.logging_out"))
          driver.logout(config.registry)
          env[:ui].output(I18n.t("vagrant_tart.messages.logged_out"))
        end
      end
    end
  end
end
