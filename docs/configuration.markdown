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
- `audio` (boolean): Whether to enable audio
- `clipboard` (boolean): Whether to enable clipboard sharing
- `cpus` (integer): Number of CPUs
- `memory` (integer): Amount of memory in MB
- `disk` (integer): Disk size in GB
- `display` (string): Display resolution
- `suspendable` (boolean): Whether the VM can be suspended
- `vnc` (boolean): Whether to use the built-in VNC server
- `vnc_experimental` (boolean): Whether to use the Virtualization.Framework's VNC server
- `extra_run_args` (array): Extra arguments to pass to the `run` command

```ruby
Vagrant.configure("2") do |config|
  config.vm.provider "tart" do |tart|
    tart.image = "ghcr.io/cirruslabs/macos-sonoma-vanilla:latest"
    tart.name = "hello-tart"
    # Customize the VM
    tart.gui = true
    tart.audio = true
    tart.clipboard = true
    tart.cpus = 4
    tart.memory = 4096
    tart.disk = 50
    tart.display = "1024x768"
    tart.suspendable = true
    tart.vnc = true
    tart.vnc_experimental = true
    tart.extra_run_args = ["--capture-system-keys"]
  end
  config.ssh.username = "admin"
  config.ssh.password = "admin"
end
```

{: .info }
The `gui`, `audio`, `clipboard`, `cpus`, `memory`, `disk`, `display` and `suspendable` are optional fields for the Tart provider.
If not specified, the default values from the image are used.

{: .info }
The `suspendable` flag is only available for some images.
Check the image documentation to see if it is supported.

{: .info }
The `vnc` and `vnc_experimental` flags are only available for some images.
Check the image documentation to see if it is supported.

{: .info }
The `extra_run_args` values will be passed **as-is** to the `tart run` command.
Be careful with the arguments you pass, as they can affect the VM's behavior.

## Networking

The networking configuration can be adjusted.
This is useful when using the bridged network mode or when the IP resolver needs to be customized.

The IP resolver can be configured:
- `ip_resolver` (string): The IP resolver to use (either `dhcp` or `arp`)

It is also possible to configure explicitly the host IP address for the SSH connection details, when `tart` is not able to resolve it automatically:
- `config.ssh.host` (string): The host IP address

```ruby
Vagrant.configure("2") do |config|
  config.vm.provider "tart" do |tart|
    tart.image = "ghcr.io/cirruslabs/macos-sonoma-vanilla:latest"
    tart.name = "hello-tart"

    tart.ip_resolver = "dhcp"
  end
  config.ssh.host = "192.168.0.42"
  config.ssh.username = "admin"
  config.ssh.password = "admin"
end
```

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

## Custom Registry

The Tart provider supports custom registries, either authenticated or unauthenticated.

```ruby
Vagrant.configure("2") do |config|
  config.vm.provider "tart" do |tart|
    tart.image = "ghcr.io/cirruslabs/macos-sonoma-vanilla:latest"
    tart.name = "hello-tart"
    # Specify custom registry
    tart.registry = "https://ghcr.io"
    # Optional username and password for authenticated registry
    tart.username = "username"
    tart.password = "password"
  end
  config.ssh.username = "admin"
  config.ssh.password = "admin"
end
```

{: .info }
The `username` and `password` are optional when using a custom authenticated registry.
The `tart` CLI tool can use either [Docker credentials helper](https://docs.docker.com/engine/reference/commandline/login/#credential-helpers) or [environment variables](https://tart.run/integrations/vm-management/#working-with-a-remote-oci-container-registry) to authenticate with the registry.
