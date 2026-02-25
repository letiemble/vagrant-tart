# frozen_string_literal: true

require "i18n"
require "vagrant/util/ansi_escape_code_remover"

module VagrantPlugins
  module Tart
    module Action
      # Action block to create a virtual machine.
      class CreateInstance
        include Vagrant::Util::ANSIEscapeCodeRemover

        def initialize(app, _env)
          @app = app
        end

        def call(env)
          machine = env[:machine]
          config = machine.provider_config
          driver = machine.provider.driver
          image = config.image
          name = machine.id || config.name
          name = default_name(env, machine) if name.nil? || name.empty?

          list = driver.list
          return @app.call(env) if list.any?(name)

          env[:ui].output(I18n.t("vagrant_tart.messages.cloning_instance", image: image, name: name))
          driver.clone(image, name) do |_type, data|
            data = remove_ansi_escape_codes(data.chomp).chomp
            env[:ui].detail(data) if data != ""
          end
          env[:ui].output(I18n.t("vagrant_tart.messages.instance_cloned", image: image, name: name))

          # Set the ID and name of the virtual machine
          machine.id = name

          @app.call(env)
        end

        private

        def default_name(env, machine)
          folder_name = File.basename(env[:root_path].to_s)
          [folder_name, machine.name, Time.now.to_i].join("_")
        end
      end
    end
  end
end
