# frozen_string_literal: true

RSpec.describe VagrantPlugins::Tart do
  it "has a version number" do
    version = described_class::VERSION
    expect(version).not_to be_nil
  end
end
