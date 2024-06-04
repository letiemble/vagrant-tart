# frozen_string_literal: true

module VagrantPlugins
  module Tart
    module Action
      # Action block to get the state of a virtual machine.
      class GetState
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          machine = env[:machine]
          config = machine.provider_config
          driver = machine.provider.driver
          name = config.name

          list = driver.list
          instance = list.find(name)

          env[:machine_state_id] = if instance.nil?
                                     :not_created
                                   else
                                     instance.vagrant_state
                                   end

          @app.call(env)
        end
      end
    end
  end
end
