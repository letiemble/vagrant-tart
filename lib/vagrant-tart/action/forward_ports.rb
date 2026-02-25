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
          machine.provider.driver
          machine.id

          @app.call(env)
        end
      end
    end
  end
end
