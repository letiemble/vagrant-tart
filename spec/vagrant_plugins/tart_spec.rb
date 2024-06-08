# frozen_string_literal: true

RSpec.describe VagrantPlugins::Tart do
  subject(:sut) { described_class }

  it "has a version number" do
    version = sut::VERSION
    expect(version).not_to be_nil
  end
end
