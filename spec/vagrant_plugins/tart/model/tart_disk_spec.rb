# frozen_string_literal: true

RSpec.describe VagrantPlugins::Tart::Model::TartDisk do
  describe "#initialize" do
    it "creates an auto-mounted disk at the root of /Volumes/My Shared Files" do
      data = {
        hostpath: "/Users/tart",
        guestpath: "/Volumes/My Shared Files"
      }
      disk = described_class.new(data)
      expect(disk.to_tart_disk).to eq("/Users/tart:tag=com.apple.virtio-fs.automount")
    end

    it "creates an auto-mounted disk at the root of /Volumes/My Shared Files/tart" do
      data = {
        hostpath: "/Users/tart",
        guestpath: "/Volumes/My Shared Files/tart"
      }
      disk = described_class.new(data)
      expect(disk.to_tart_disk).to eq("tart:/Users/tart:tag=com.apple.virtio-fs.automount")
    end

    it "creates a read-only tag-mounted disk" do
      data = {
        hostpath: "/Users/tart",
        guestpath: "/vagrant/tart",
        mount_options: ["mode=ro", "tag=vagrant"]
      }
      disk = described_class.new(data)
      expect(disk.to_tart_disk).to eq("/Users/tart:ro,tag=vagrant")
    end
  end
end
