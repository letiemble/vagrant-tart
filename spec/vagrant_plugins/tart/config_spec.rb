# frozen_string_literal: true

RSpec.describe VagrantPlugins::Tart::Config do
  subject(:sut) { described_class.new }

  describe "#validate" do
    it "reports no error when configuration is valid" do
      sut.image = "ghcr.io/cirruslabs/ubuntu:latest"
      sut.name = "ubuntu"
      sut.finalize!

      result = sut.validate(nil)

      expect(result["Tart Provider"].size).to eq(0)
    end

    it "raises an error if 'image' has no value" do
      sut.image = nil
      sut.name = "ubuntu"
      sut.finalize!

      result = sut.validate(nil)

      expect(result["Tart Provider"].size).to eq(1)
    end

    it "raises an error if 'name' has no value" do
      sut.image = "ghcr.io/cirruslabs/ubuntu:latest"
      sut.name = nil
      sut.finalize!

      result = sut.validate(nil)

      expect(result["Tart Provider"].size).to eq(1)
    end

    it "raises an error if 'gui' has not a boolean value" do
      sut.image = "ghcr.io/cirruslabs/ubuntu:latest"
      sut.name = "ubuntu"
      sut.gui = "invalid"
      sut.finalize!

      result = sut.validate(nil)

      expect(result["Tart Provider"].size).to eq(1)
    end

    it "raises an error if 'cpus' has not an integer value" do
      sut.image = "ghcr.io/cirruslabs/ubuntu:latest"
      sut.name = "ubuntu"
      sut.cpus = "invalid"
      sut.finalize!

      result = sut.validate(nil)

      expect(result["Tart Provider"].size).to eq(1)
    end

    it "raises an error if 'cpus' has an invalid integer value" do
      sut.image = "ghcr.io/cirruslabs/ubuntu:latest"
      sut.name = "ubuntu"
      sut.cpus = 0
      sut.finalize!

      result = sut.validate(nil)

      expect(result["Tart Provider"].size).to eq(1)
    end

    it "raises an error if 'memory' has not an integer value" do
      sut.image = "ghcr.io/cirruslabs/ubuntu:latest"
      sut.name = "ubuntu"
      sut.memory = "invalid"
      sut.finalize!

      result = sut.validate(nil)

      expect(result["Tart Provider"].size).to eq(1)
    end

    it "raises an error if 'memory' has an invalid integer value" do
      sut.image = "ghcr.io/cirruslabs/ubuntu:latest"
      sut.name = "ubuntu"
      sut.memory = 0
      sut.finalize!

      result = sut.validate(nil)

      expect(result["Tart Provider"].size).to eq(1)
    end

    it "raises an error if 'disk' has not an integer value" do
      sut.image = "ghcr.io/cirruslabs/ubuntu:latest"
      sut.name = "ubuntu"
      sut.disk = "invalid"
      sut.finalize!

      result = sut.validate(nil)

      expect(result["Tart Provider"].size).to eq(1)
    end

    it "raises an error if 'disk' has an invalid integer value" do
      sut.image = "ghcr.io/cirruslabs/ubuntu:latest"
      sut.name = "ubuntu"
      sut.disk = 0
      sut.finalize!

      result = sut.validate(nil)

      expect(result["Tart Provider"].size).to eq(1)
    end

    it "raises an error if 'display' has an invalid value" do
      sut.image = "ghcr.io/cirruslabs/ubuntu:latest"
      sut.name = "ubuntu"
      sut.display = "invalid"
      sut.finalize!

      result = sut.validate(nil)

      expect(result["Tart Provider"].size).to eq(1)
    end

    it "raises an error if 'suspendable' has not a boolean value" do
      sut.image = "ghcr.io/cirruslabs/ubuntu:latest"
      sut.name = "ubuntu"
      sut.suspendable = "invalid"
      sut.finalize!

      result = sut.validate(nil)

      expect(result["Tart Provider"].size).to eq(1)
    end
  end

  describe "#use_registry?" do
    it "returns false when no registry is configured" do
      sut.registry = nil
      sut.finalize!

      expect(sut.use_registry?).to be(false)
    end

    it "returns true when a registry is configured" do
      sut.registry = "ghcr.io"
      sut.finalize!

      expect(sut.use_registry?).to be(true)
    end
  end
end
