# frozen_string_literal: true

require_relative "action_spec_helper"

RSpec.describe VagrantPlugins::Tart::Action::GetState do
  subject(:sut) { described_class.new(app, env) }

  let(:config)   { instance_double("config", image: "image", name: "name") }
  let(:provider) { instance_double("provider", driver: driver) }
  let(:ui)       { instance_double("ui", output: nil, detail: nil) }
  let(:machine)  { instance_double("machine", provider_config: config, provider: provider, ui: ui) }
  let(:env)      { { machine: machine, ui: machine.ui, root_path: Pathname.new(".") } }
  let(:app)      { ->(*args) {} }
  let(:driver)   { instance_double("driver") }

  describe "#call" do
    it("does return the state 'not created' when the instance does not exist") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_without_instance)
      expect(app).to receive(:call).with(env)

      sut.call(env)

      expect(env[:machine_state_id]).to eq(:not_created)
    end

    it("does return the state 'running' when the instance does exist and is running") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_with_instance_running)
      expect(app).to receive(:call).with(env)

      sut.call(env)

      expect(env[:machine_state_id]).to eq(:running)
    end

    it("does return the state 'stopped' when the instance does exist and is stopped") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_with_instance_stopped)
      expect(app).to receive(:call).with(env)

      sut.call(env)

      expect(env[:machine_state_id]).to eq(:stopped)
    end

    it("does return the state 'stopped' when the instance does exist and is suspended") do
      allow(driver).to receive(:list)
        .and_return(VagrantPlugins::Tart::Action::ActionSpecHelper.list_with_instance_suspended)
      expect(app).to receive(:call).with(env)

      sut.call(env)

      expect(env[:machine_state_id]).to eq(:stopped)
    end
  end
end
