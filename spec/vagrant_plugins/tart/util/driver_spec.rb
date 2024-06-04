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

  describe "#list" do
    let(:stdout) { "[\n\n]" }

    it "lists Tart virtual machines" do
      result = sut.list
      expect(result.machines).to eq([])
    end
  end
end
# rubocop:enable RSpec/InstanceVariable, RSpec/VerifiedDoubles
