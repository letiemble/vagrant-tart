# frozen_string_literal: true

require "i18n"

module VagrantPlugins
  module Tart
    module Action
      # Action block to setup forwarded ports for a virtual machine.
      class ForwardPorts
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          machine = env[:machine]
          config = machine.provider_config
          machine.provider.driver
          config.name

          @app.call(env)
        end
      end
    end
  end
end
