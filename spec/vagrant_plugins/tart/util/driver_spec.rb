# frozen_string_literal: false

# rubocop:disable RSpec/InstanceVariable, RSpec/VerifiedDoubles
RSpec.describe VagrantPlugins::Tart::Util::Driver do
  subject(:sut) { described_class.new }

  let(:cmd_executed) { @cmd }
  let(:execute_result) do
    double("execute_result",
           exit_code: exit_code,
           stderr: stderr,
           stdout: stdout)
  end
  let(:exit_code) { 0 }
  let(:stderr) { "" }
  let(:stdout) { "" }

  before do
    allow(Vagrant::Util::Subprocess).to receive(:execute) { |*args|
      args = args[0, args.size - 1] if args.last.is_a?(Hash)
      invalid = args.detect { |a| !a.is_a?(String) }
      if invalid
        raise TypeError,
              "Vagrant::Util::Subprocess#execute only accepts Hash or String arguments, received `#{invalid.class}'"
      end
      @cmd = args.join(" ")
    }.and_return(execute_result)
  end

  describe "#get" do
    describe "#ok" do
      let(:stdout) { File.read("spec/fixtures/util/driver_spec_get.json") }

      it "gets the machine detail" do
        result = sut.get("dummy")
        expect(result.cpus).to eq(1)
        expect(result.memory).to eq(1024)
        expect(result.disk).to eq(20)
      end
    end

    describe "#error" do
      let(:exit_code) { 1 }

      it "fails to get the machine detail" do
        expect { sut.get("dummy") }.to raise_error(VagrantPlugins::Tart::Errors::CommandError)
      end
    end
  end

  describe "#ip" do
    describe "#ok" do
      let(:stdout) { "192.168.42.1" }

      it "gets the machine IP" do
        result = sut.ip("dummy", "dhcp")
        expect(result).to eq("192.168.42.1")
      end
    end

    # describe "#nok" do
    # let(:stdout) { "The machine is not started" }

    #   it "gets the machine IP" do
    #     result = sut.ip("dummy", "dhcp")
    #     expect(result).to eq("")
    #   end
    # end

    describe "#error" do
      let(:exit_code) { 1 }

      it "fails to get the machine IP" do
        expect { sut.ip("dummy", "arp") }.to raise_error(VagrantPlugins::Tart::Errors::CommandError)
      end
    end
  end

  describe "#list" do
    describe "#empty" do
      let(:stdout) { File.read("spec/fixtures/util/driver_spec_list_empty.json") }

      it "lists the machines" do
        result = sut.list
        expect(result.machines.size).to eq(0)
      end
    end

    describe "#filled" do
      let(:stdout) { File.read("spec/fixtures/util/driver_spec_list_filled.json") }

      it "lists the machines" do
        result = sut.list
        expect(result.machines.size).to eq(4)
      end
    end

    describe "#error" do
      let(:exit_code) { 1 }

      it "fails to list the machines" do
        expect { sut.list }.to raise_error(VagrantPlugins::Tart::Errors::CommandError)
      end
    end
  end

  describe "#set" do
    describe "#ok" do
      let(:exit_code) { 0 }

      it "sets the machine parameter" do
        expect { sut.set("dummy", "memory", 1024) }.not_to raise_error
      end
    end

    describe "#invalid" do
      let(:exit_code) { 1 }

      it "ignore the machine parameter" do
        expect { sut.set("dummy", "nop", "something") }.not_to raise_error
      end
    end

    describe "#error" do
      let(:exit_code) { 1 }

      it "fails to set the machine parameter" do
        expect { sut.set("dummy", "memory", 1024) }.to raise_error(VagrantPlugins::Tart::Errors::CommandError)
      end
    end
  end
end
# rubocop:enable RSpec/InstanceVariable, RSpec/VerifiedDoubles
