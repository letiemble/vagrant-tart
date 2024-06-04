# frozen_string_literal: true

require "i18n"
require "vagrant/util/ansi_escape_code_remover"

module VagrantPlugins
  module Tart
    module Action
      # Action to pull a virtual machine image.
      class PullImage
        include Vagrant::Util::ANSIEscapeCodeRemover

        def initialize(app, _env)
          @app = app
        end

        def call(env)
          machine = env[:machine]
          config = machine.provider_config
          driver = machine.provider.driver
          image = config.image

          # Check if the virtual machine image is already present
          list = driver.list
          return @app.call(env) if list.any?(image)

          env[:ui].output(I18n.t("vagrant_tart.messages.pulling_image", image: image))
          driver.pull(image) do |_type, data|
            data = remove_ansi_escape_codes(data.chomp).chomp
            data = data.gsub("\r", "")
            env[:ui].detail(data) if data != ""
          end
          env[:ui].output(I18n.t("vagrant_tart.messages.image_pulled", image: image))

          @app.call(env)
        end
      end
    end
  end
end
