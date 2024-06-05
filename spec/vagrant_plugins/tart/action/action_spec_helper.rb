# frozen_string_literal: true

module VagrantPlugins
  module Tart
    module Action
      # rubocop:disable Naming/AccessorMethodName
      class ActionSpecHelper
        def self.list_with_image
          payload = File.read("spec/fixtures/action/list_with_image.json")
          data = JSON.parse(payload)
          VagrantPlugins::Tart::Model::ListResult.new(data)
        end

        def self.list_without_image
          payload = File.read("spec/fixtures/action/list_without_image.json")
          data = JSON.parse(payload)
          VagrantPlugins::Tart::Model::ListResult.new(data)
        end

        def self.list_without_instance
          payload = File.read("spec/fixtures/action/list_without_instance.json")
          data = JSON.parse(payload)
          VagrantPlugins::Tart::Model::ListResult.new(data)
        end

        def self.list_with_instance_running
          payload = File.read("spec/fixtures/action/list_with_instance_running.json")
          data = JSON.parse(payload)
          VagrantPlugins::Tart::Model::ListResult.new(data)
        end

        def self.list_with_instance_stopped
          payload = File.read("spec/fixtures/action/list_with_instance_stopped.json")
          data = JSON.parse(payload)
          VagrantPlugins::Tart::Model::ListResult.new(data)
        end

        def self.list_with_instance_suspended
          payload = File.read("spec/fixtures/action/list_with_instance_suspended.json")
          data = JSON.parse(payload)
          VagrantPlugins::Tart::Model::ListResult.new(data)
        end

        def self.get_with_instance_running
          payload = File.read("spec/fixtures/action/get_with_instance_running.json")
          data = JSON.parse(payload)
          VagrantPlugins::Tart::Model::GetResult.new(data)
        end

        def self.get_with_instance_stopped
          payload = File.read("spec/fixtures/action/get_with_instance_stopped.json")
          data = JSON.parse(payload)
          VagrantPlugins::Tart::Model::GetResult.new(data)
        end
      end
      # rubocop:enable Naming/AccessorMethodName
    end
  end
end
