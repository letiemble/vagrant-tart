# frozen_string_literal: true

RSpec.describe VagrantPlugins::Tart::Model::TartDisk do
  describe "#initialize" do
    it "creates an auto-mounted disk at the root of /Volumes/My Shared Files" do
      data = {
        hostpath: "/Users/tart",
        guestpath: "/Volumes/My Shared Files",
        mount_options: ["tag=com.apple.virtio-fs.automount"]
      }
      disk = described_class.new(data)
      expect(disk.to_tart_disk).to eq("/Users/tart:tag=com.apple.virtio-fs.automount")
    end

    it "creates an auto-mounted disk at the root of /Volumes/My Shared Files/tart" do
      data = {
        hostpath: "/Users/tart",
        guestpath: "/Volumes/My Shared Files/tart",
        mount_options: ["tag=com.apple.virtio-fs.automount"]
      }
      disk = described_class.new(data)
      expect(disk.to_tart_disk).to eq("tart:/Users/tart:tag=com.apple.virtio-fs.automount")
    end

    it "creates a disk with the specifed tag and mode" do
      data = {
        hostpath: "/Users/tart",
        guestpath: "/vagrant/tart",
        mount_options: ["mode=rw", "tag=vagrant"]
      }
      disk = described_class.new(data)
      expect(disk.to_tart_disk).to eq("/Users/tart:tag=vagrant")
    end

    it "creates a disk with an automatically generated (md5) tag when none is provided" do
      data = {
        hostpath: "/Users/tart",
        guestpath: "/vagrant/tart"
      }
      disk = described_class.new(data)
      tag = Digest::MD5.hexdigest(data[:guestpath])
      expect(disk.to_tart_disk).to eq("/Users/tart:tag=#{tag}")
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
