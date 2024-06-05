# frozen_string_literal: true

require_relative "action_spec_helper"

RSpec.describe VagrantPlugins::Tart::Action::Login do
  subject(:sut) { described_class.new(app, env) }

  let(:config)   { instance_double("config", image: "image", name: "name") }
  let(:provider) { instance_double("provider", driver: driver) }
  let(:ui)       { instance_double("ui", output: nil, detail: nil) }
  let(:machine)  { instance_double("machine", provider_config: config, provider: provider, ui: ui) }
  let(:env)      { { machine: machine, ui: machine.ui, root_path: Pathname.new(".") } }
  let(:app)      { ->(*args) {} }
  let(:driver)   { instance_double("driver") }

  describe "#call" do
    describe "when the registry is not used" do
      let(:config) do
        instance_double("config", image: "image", name: "name", use_registry?: false)
      end

      it("does nothing when the registry is not used") do
        expect(app).to receive(:call).with(env)

        sut.call(env)
      end
    end

    describe "when the registry is used" do
      let(:config) do
        instance_double("config", image: "image", name: "name", use_registry?: true,
                                  registry: "registry", username: "username", password: "password")
      end

      it("does login to the registry") do
        expect(driver).to receive(:login).with("registry", "username", "password")
        expect(app).to receive(:call).with(env)
        expect(driver).to receive(:logout).with("registry")

        sut.call(env)
      end
    end
  end
end
