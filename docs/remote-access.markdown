---
title: Remote Access
nav_order: 4
---

A Vagrant virtual machine provides several ways to access the guest operating system remotely.

## SSH

By default, vagrant provides an SSH connection to the virtual machine.

Take the following configuration for a Tart virtual machine:

```ruby
Vagrant.configure("2") do |config|
  config.vm.provider "tart" do |tart|
    tart.image = "ghcr.io/cirruslabs/macos-sonoma-vanilla:latest"
    tart.name = "hello-tart"
  end
  config.ssh.username = "admin"
  config.ssh.password = "admin"
end
```

The virtual machine can be accessed via SSH using the `vagrant ssh` command.

```shell
vagrant up
vagrant ssh
```

This will open a remote shell session to the virtual machine.
See [Configuration]({{ '/configuration | relative_url }}) for more information on how to configure a Tart virtual machine.

## VNC

By setting the VNC option, the virtual machine can be accessed using a VNC client.

Take the following configuration for a Tart virtual machine:

```ruby
Vagrant.configure("2") do |config|
  config.vm.provider "tart" do |tart|
    tart.image = "ghcr.io/cirruslabs/macos-sonoma-vanilla:latest"
    tart.name = "hello-tart"
    # Disable the GUI
    tart.gui = false
    # Enable the VNC server
    tart.vnc = true
  end
  config.ssh.username = "admin"
  config.ssh.password = "admin"
end
```

The virtual machine can be accessed via VNC using the `vagrant vnc` command.

```shell
vagrant up
vagrant vnc
```

This will open a VNC session to the virtual machine, by using the default application registered for the `vnc://` protocol.
See [Configuration]({{ '/configuration | relative_url }}) for more information on how to configure a Tart virtual machine.
