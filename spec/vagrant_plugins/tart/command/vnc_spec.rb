# frozen_string_literal: true

# rubocop:disable RSpec/MessageSpies
RSpec.describe VagrantPlugins::Tart::Command::VNC do
  subject(:sut) { described_class.new(argv, env) }

  let(:provider) { instance_double("provider", to_sym: "") }
  let(:ui) { instance_double("ui", output: nil, detail: nil, opts: {}) }
  let(:state) { instance_double("state", id: 123) }
  let(:machine) do
    instance_double(
      "machine",
      name: "vm",
      provider: provider,
      ui: ui,
      vagrant_env: env,
      state: state,
      index_uuid: "00000000-0000-0000-0000-000000000000"
    )
  end
  let(:env) { instance_double("env") }
  let(:machine_index) { instance_double("machine_index") }
  let(:argv) { [] }

  before do
    allow(env).to receive_messages(
      ui_class: Vagrant::UI::Colored,
      root_path: "/path/to/root",
      home_path: "/path/to/home",
      active_machines: [["vm", :provider]],
      machine: machine,
      machine_names: ["vm"],
      machine_index: machine_index
    )
    allow(machine_index).to receive_messages(
      get: machine,
      release: nil,
      include?: true
    )
    allow(machine).to receive_messages(
      ssh_info: { host: "192.168.15.1", username: "vagrant", password: "vagrant" }
    )
    allow(machine).to receive(:action)
  end

  describe "#execute" do
    it("succeeds with no options") do
      expect(sut.execute).to eq(0)

      vnc_info = { host: "192.168.15.1", username: "vagrant", password: "vagrant", extra_args: nil }
      expect(machine).to have_received(:action).with(:vnc_connect, vnc_info: vnc_info)
    end

    describe "with an invalid option" do
      let(:argv) { ["-d"] }

      it("fails with the help message") do
        expect { sut.execute }.to raise_error(Vagrant::Errors::CLIInvalidOptions)
      end
    end

    describe "with an invalid option value" do
      let(:argv) { ["-u"] }

      it("fails with the help message") do
        expect { sut.execute }.to raise_error(Vagrant::Errors::CLIInvalidOptions)
      end
    end

    describe "with a username" do
      let(:argv) { ["-u", "user"] }

      it("uses provided username") do
        expect(sut.execute).to eq(0)

        vnc_info = { host: "192.168.15.1", username: "user", password: nil, extra_args: nil }
        expect(machine).to have_received(:action).with(:vnc_connect, vnc_info: vnc_info)
      end
    end

    describe "with a username and password" do
      let(:argv) { ["-u", "user", "-p", "pwd"] }

      it("uses provided username/password") do
        expect(sut.execute).to eq(0)

        vnc_info = { host: "192.168.15.1", username: "user", password: "pwd", extra_args: nil }
        expect(machine).to have_received(:action).with(:vnc_connect, vnc_info: vnc_info)
      end
    end
  end
end
# rubocop:enable RSpec/MessageSpies
