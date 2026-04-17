# frozen_string_literal: true

module VagrantPlugins
  module Tart
    module Action
      # Populates env[:nfs_valid_ids] so Vagrant's NFS synced folder cleanup
      # can prune stale exports without raising NFSNoValidIds on a fresh `up`.
      class PrepareNFSValidIds
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          env[:nfs_valid_ids] =
            env[:machine].provider.driver.list.machines.map(&:name)
          @app.call(env)
        end
      end
    end
  end
end
