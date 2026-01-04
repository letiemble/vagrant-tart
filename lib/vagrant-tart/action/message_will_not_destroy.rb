# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: BUSL-1.1
# frozen_string_literal: true

require "i18n"

module VagrantPlugins
  module Tart
    module Action
      # Action block to inform the user that the machine will not be destroyed.
      class MessageWillNotDestroy
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t("vagrant.commands.destroy.will_not_destroy",
                               name: env[:machine].name)
          @app.call(env)
        end
      end
    end
  end
end
