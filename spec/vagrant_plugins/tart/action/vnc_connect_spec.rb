# frozen_string_literal: true

require_relative "action_spec_helper"

RSpec.describe VagrantPlugins::Tart::Action::VNCConnect do
  subject(:sut) { described_class.new(app, env) }

  let(:config)   { instance_double("config", image: "image", name: "name") }
  let(:provider) { instance_double("provider", driver: driver) }
  let(:ui)       { instance_double("ui", output: nil, detail: nil) }
  let(:machine)  { instance_double("machine", provider_config: config, provider: provider, ui: ui) }
  let(:vnc_info) { {} }
  let(:env)      { { machine: machine, ui: machine.ui, root_path: Pathname.new("."), vnc_info: vnc_info } }
  let(:app)      { ->(*args) {} }
  let(:driver)   { instance_double("driver") }

  describe "#call" do
    it("does not start a VNC connection when the instance does not exist") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_without_instance)
      expect(driver).not_to receive(:get).with("name")
      expect(driver).not_to receive(:vnc_connect).with({})
      expect(app).to receive(:call).with(env)

      sut.call(env)
    end

    it("does not start a VNC connection when the instance is nil") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_with_instance_running)
      allow(driver).to receive(:get)
        .with("name")
        .and_return(nil)
      expect(driver).not_to receive(:vnc_connect).with({})
      expect(app).to receive(:call).with(env)

      sut.call(env)
    end

    it("does not start a VNC connection when the instance is not running") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_with_instance_stopped)
      allow(driver).to receive(:get)
        .with("name")
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.get_with_instance_stopped)
      expect(driver).not_to receive(:vnc_connect).with({})
      expect(app).to receive(:call).with(env)

      sut.call(env)
    end

    it("starts a VNC connection when the instance is running") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_with_instance_running)
      allow(driver).to receive(:get)
        .with("name")
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.get_with_instance_running)
      expect(driver).to receive(:vnc_connect).with({})
      expect(app).to receive(:call).with(env)

      sut.call(env)
    end
  end
end
