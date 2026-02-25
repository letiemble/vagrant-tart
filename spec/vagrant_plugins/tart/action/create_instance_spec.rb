# frozen_string_literal: true

require_relative "action_spec_helper"

RSpec.describe VagrantPlugins::Tart::Action::CreateInstance do
  subject(:sut) { described_class.new(app, env) }

  let(:config)   { instance_double("config", image: "image", name: "name") }
  let(:provider) { instance_double("provider", driver: driver) }
  let(:ui)       { instance_double("ui", output: nil, detail: nil) }
  let(:machine)  do
    instance_double("machine", provider_config: config, provider: provider, ui: ui, id: nil, name: "default")
  end
  let(:env)      { { machine: machine, ui: machine.ui, root_path: Pathname.new(".") } }
  let(:app)      { ->(*args) {} }
  let(:driver)   { instance_double("driver") }

  describe "#call" do
    it("does not create the instance when the instance does exist") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_with_instance_stopped)
      expect(driver).not_to receive(:clone).with("image", "name")
      expect(app).to receive(:call).with(env)

      sut.call(env)
    end

    it("does create the instance when the instance does not exist") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_without_instance)
      expect(driver).to receive(:clone).with("image", "name").and_yield("type", "data")
      expect(machine).to receive(:id=).with("name")
      expect(app).to receive(:call).with(env)

      sut.call(env)
    end

    it("does create the instance with generated name when config.name is not set") do
      nameless_config = instance_double("config", image: "image", name: nil)
      nameless_machine = instance_double(
        "machine",
        provider_config: nameless_config,
        provider: provider,
        ui: ui,
        id: nil,
        name: "my_vm"
      )
      nameless_env = { machine: nameless_machine, ui: nameless_machine.ui, root_path: Pathname.new("project") }

      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_without_instance)
      allow(Time).to receive(:now).and_return(Time.at(1_707_000_000))

      expect(driver).to receive(:clone).with("image", "project_my_vm_1707000000").and_yield("type", "data")
      expect(nameless_machine).to receive(:id=).with("project_my_vm_1707000000")
      expect(app).to receive(:call).with(nameless_env)

      sut.call(nameless_env)
    end
  end
end
