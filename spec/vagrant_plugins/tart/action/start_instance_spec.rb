# frozen_string_literal: true

require_relative "action_spec_helper"

RSpec.describe VagrantPlugins::Tart::Action::StartInstance do
  subject(:sut) { described_class.new(app, env) }

  let(:config) do
    instance_double("config", image: "image", name: "name", suspendable?: true,
                              gui: true, cpu: 1, memory: 1024, disk: 20, display: "1024x768", volumes: [])
  end
  let(:provider) { instance_double("provider", driver: driver) }
  let(:ui)       { instance_double("ui", output: nil, detail: nil) }
  let(:machine)  { instance_double("machine", provider_config: config, provider: provider, ui: ui) }
  let(:env)      { { machine: machine, ui: machine.ui, root_path: Pathname.new(".") } }
  let(:app)      { ->(*args) {} }
  let(:driver)   { instance_double("driver") }

  describe "#call" do
    it("does not start the instance when the instance does not exist") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_without_instance)
      expect(driver).not_to receive(:get).with("name")
      expect(driver).not_to receive(:run).with("name", true, true, [])
      expect(app).to receive(:call).with(env)

      sut.call(env)
    end

    it("does not start the instance when the instance is nil") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_with_instance_running)
      allow(driver).to receive(:get).with("name").and_return(nil)
      expect(driver).not_to receive(:set)
      expect(driver).not_to receive(:run)
      expect(app).to receive(:call).with(env)

      sut.call(env)
    end

    it("does not start the instance when the instance is running") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_with_instance_running)
      allow(driver).to receive(:get)
        .with("name")
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.get_with_instance_running)
      expect(driver).not_to receive(:set)
      expect(driver).not_to receive(:run)
      expect(app).to receive(:call).with(env)

      sut.call(env)
    end

    it("starts the instance when the instance is stopped") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_with_instance_stopped)
      allow(driver).to receive(:get)
        .with("name")
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.get_with_instance_stopped)
      expect(driver).to receive(:set).with("name", "cpu", 1)
      expect(driver).to receive(:set).with("name", "memory", 1024)
      expect(driver).to receive(:set).with("name", "disk", 20)
      expect(driver).to receive(:set).with("name", "display", "1024x768")
      expect(driver).to receive(:run).with("name", true, true, [])
      expect(app).to receive(:call).with(env)

      sut.call(env)
    end
  end
end
