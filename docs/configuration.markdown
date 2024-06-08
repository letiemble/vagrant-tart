---
title: Configuration
nav_order: 3
---

A Vagrant virtual machine is configured using a `Vagrantfile`.
This file is a Ruby script that configures the virtual machine and its provider.
The Tart provider is configured using the `config.vm.provider` method.
See [Vagrantfile](https://developer.hashicorp.com/vagrant/docs/vagrantfile) for more information.

## Basic

Below is the simplest configuration for a Tart virtual machine:

```ruby
Vagrant.configure("2") do |config|
  config.vm.provider "tart" do |tart|
    # The image (it can be a local or remote image)
    tart.image = "ghcr.io/cirruslabs/macos-sonoma-vanilla:latest"
    # The name of the virtual machine
    tart.name = "hello-tart"
  end
  # These are the default values for a Tart VM
  config.ssh.username = "admin"
  config.ssh.password = "admin"
end
```

{: .info }
The `image` and `name` are required fields for the Tart provider.
The `name` is used to identify the virtual machine in the Tart command line tool, so it must be unique.
The `username` and `password` are required fields for the SSH connection.

## Customization

Some characteristics of the virtual machine can be customized:
- `gui` (boolean): Whether to show the GUI
- `cpus` (integer): Number of CPUs
- `memory` (integer): Amount of memory in MB
- `disk` (integer): Disk size in GB
- `display` (string): Display resolution

```ruby
Vagrant.configure("2") do |config|
  config.vm.provider "tart" do |tart|
    tart.image = "ghcr.io/cirruslabs/macos-sonoma-vanilla:latest"
    tart.name = "hello-tart"
    # Customize the VM
    tart.gui = true
    tart.cpus = 4
    tart.memory = 4096
    tart.disk = 50
    tart.display = "1024x768"
  end
  config.ssh.username = "admin"
  config.ssh.password = "admin"
end
```

{: .info }
The `gui`, `cpus`, `memory`, `disk`, and `display` are optional fields for the Tart provider.
If not specified, the default values from the image are used.

## Provisioning

Virtual machines can be provisioned using the `config.vm.provision` method.
Vagrant supports multiple provisioners, such as `shell`, `ansible`, `chef`, `puppet`, etc.
See [Vagrant Provisioning](https://www.vagrantup.com/docs/provisioning) for more information.

```ruby
Vagrant.configure("2") do |config|
  config.vm.provider "tart" do |tart|
    tart.image = "ghcr.io/cirruslabs/macos-sonoma-vanilla:latest"
    tart.name = "hello-tart"
  end
  config.ssh.username = "admin"
  config.ssh.password = "admin"

  # Provision the VM by running a shell script
  config.vm.provision "shell", inline: <<-SHELL
    echo "Hello, Tart!"
  SHELL

  # Provision the VM by copying a file
  config.vm.provision "file", source: "PROVISION.txt", destination: "~/"
end
```

## Synced Folders

Vagrant supports synced folders to share files between the host and the guest.
The `config.vm.synced_folder` method is used to configure synced folders.
See [Vagrant Synced Folders](https://www.vagrantup.com/docs/synced-folders) for more information.

```ruby
Vagrant.configure("2") do |config|
  config.vm.provider "tart" do |tart|
    tart.image = "ghcr.io/cirruslabs/macos-sonoma-vanilla:latest"
    tart.name = "hello-tart"
  end
  config.ssh.username = "admin"
  config.ssh.password = "admin"

  # Disable the default synced folder
  config.vm.synced_folder ".", "/vagrant", disabled: true
  # Enable a synced folder with the host (the current folder) and the guest (/Volumes/shared/vagrant)
  config.vm.synced_folder ".", "/Volumes/My Shared Files/vagrant"
  # Enable a synced folder with the host (./shared1) and the guest (/Volumes/shared1)
  config.vm.synced_folder "./shared1", "/Volumes/shared1", mount_options: ["tag=shared1"]
  # Enable a read-only synced folder with the host (./shared2) and the guest (/Volumes/shared2)
  config.vm.synced_folder "./shared2", "/Volumes/shared2", mount_options: ["mode=ro", "tag=shared2"]
end
```

{: .warning }
All the synced folders are mounted in the guest at boot time.
The command `vagrant reload` is required to apply changes to the synced folders.
