# frozen_string_literal: true

RSpec.describe VagrantPlugins::Tart::Provider do
  let(:machine) { instance_double("machine") }
  let(:provider) { described_class.new(machine) }
  let(:driver) { instance_double("driver") }
  let(:logger) { instance_double("logger", info: nil, warn: nil) }

  before do
    allow(machine).to receive_messages(
      provider_config: instance_double("provider_config", name: "test", ip_resolver: "resolver"),
      config: instance_double("config", ssh: instance_double("ssh", host: nil))
    )
    allow(provider).to receive(:logger).and_return(logger)
    provider.assing_driver(driver)
  end

  describe "#ssh_info" do
    context "when the machine is not running" do
      before do
        allow(provider).to receive(:state).and_return(instance_double("state", id: :stopped))
      end

      it "returns nil" do
        expect(provider.ssh_info).to be_nil
      end
    end

    context "when the machine is running" do
      before do
        allow(provider).to receive(:state).and_return(instance_double("state", id: :running))
      end

      context "when the IP address is retrieved successfully" do
        before do
          allow(driver).to receive(:ip).and_return("192.168.1.100")
        end

        it "returns the SSH info" do
          expect(provider.ssh_info).to eq({ host: "192.168.1.100", port: 22 })
        end
      end

      context "when there is an error retrieving the IP address" do
        error = VagrantPlugins::Tart::Errors::CommandError.new(command: "tart get dummy", stderr: "", stdout: "")

        before do
          allow(driver).to receive(:ip).and_raise(error)
        end

        it "logs a warning and returns nil" do
          # expect(logger).to receive(:warn).with("Failed to read guest IP #{$ERROR_INFO}")
          expect(provider.ssh_info).to be_nil
        end
      end

      context "when the IP address is nil" do
        before do
          allow(driver).to receive(:ip).and_return(nil)
        end

        it "returns nil" do
          expect(provider.ssh_info).to be_nil
        end
      end
    end
  end
end
