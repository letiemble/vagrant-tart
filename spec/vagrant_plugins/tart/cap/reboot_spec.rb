# frozen_string_literal: true

# rubocop:disable RSpec/MessageSpies
RSpec.describe VagrantPlugins::Tart::Cap::Reboot do
  subject(:sut) { described_class }

  let(:provider) { instance_double("provider", to_sym: "") }
  let(:ui) { instance_double("ui", output: nil, detail: nil, opts: {}) }
  let(:state) { instance_double("state", id: 123) }
  let(:machine) do
    instance_double(
      "machine",
      name: "vm",
      ui: ui
    )
  end
  let(:communicate) { instance_double("communicator") }

  before do
    allow(machine).to receive(:communicate).and_return(communicate)
    allow(ui).to receive(:info)
    allow(ui).to receive(:error)
  end

  describe "#reboot" do
    it("succeeds when the machine reboots") do
      allow(communicate).to receive(:sudo).and_return(true)
      allow(described_class).to receive(:sleep).and_return(true)

      sut.reboot(machine)

      expect(communicate).to have_received(:sudo).with("shutdown -r now")
      expect(ui).to have_received(:info).with(/.+/)
    end

    it("fails when the machine cannot reboot") do
      allow(communicate).to receive(:sudo).and_raise(Vagrant::Errors::VagrantError)

      sut.reboot(machine)

      expect(communicate).to have_received(:sudo).with("shutdown -r now")
      expect(ui).to have_received(:error).with(/.+/)
    end
  end
end
# rubocop:enable RSpec/MessageSpies
