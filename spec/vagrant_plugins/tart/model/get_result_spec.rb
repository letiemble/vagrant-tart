# frozen_string_literal: true

GET_RESULT_PAYLOAD = '
{
  "Size" : "1.559",
  "Running" : false,
  "State" : "stopped",
  "OS" : "linux",
  "Disk" : 20,
  "Memory" : 4096,
  "Display" : "1024x768",
  "CPU" : 4
}
'

RSpec.describe VagrantPlugins::Tart::Model::GetResult do
  describe "#initialize" do
    it "creates a new instance from a JSON payload" do
      data = JSON.parse(GET_RESULT_PAYLOAD)
      sut = described_class.new(data)
      expect(sut.display).to eq("1024x768")
    end
  end
end
