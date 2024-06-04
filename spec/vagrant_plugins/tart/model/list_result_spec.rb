# frozen_string_literal: true

LIST_RESULT_PAYLOAD = '
[
  {
    "Disk" : 20,
    "Source" : "local",
    "Running" : false,
    "Size" : 1,
    "State" : "stopped",
    "Name" : "ubuntu"
  },
  {
    "Size" : 1,
    "Disk" : 20,
    "State" : "stopped",
    "Name" : "ghcr.io\/cirruslabs\/ubuntu:latest",
    "Source" : "oci",
    "Running" : false
  },
  {
    "Source" : "oci",
    "Running" : false,
    "State" : "stopped",
    "Name" : "ghcr.io\/cirruslabs\/ubuntu@sha256:c502647d3cd0d7a3d76e3704f4be566a1a12b5588d5a96df0f452d941899f2b7",
    "Disk" : 20,
    "Size" : 1
  }
]
'

RSpec.describe VagrantPlugins::Tart::Model::ListResult do
  describe "#initialize" do
    it "creates a new instance from a JSON payload" do
      data = JSON.parse(LIST_RESULT_PAYLOAD)
      sut = described_class.new(data)
      expect(sut.machines.size).to eq(3)
    end
  end
end
