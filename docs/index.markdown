---
title: Home
redirect_from:
  - /home/
nav_order: 1
---

Vagrant-tart is a [Vagrant](http://www.vagrantup.com) plugin that adds a
[Tart](https://tart.run/) provider to Vagrant, allowing Vagrant to
control and provision machines via Tart command line tool.

You can find the source code for Vagrant Tart plugin at GitHub:
[https://github.com/letiemble/vagrant-tart](https://github.com/letiemble/vagrant-tart)

Creating issues can be done via GitHub:
[https://github.com/letiemble/vagrant-tart/issues](https://github.com/letiemble/vagrant-tart/issues)

## Features

* Control local Tart virtual machines.
* No box required; the plugin uses Tart images.
* Support Vagrant `up`, `destroy`, `suspend`, `resume`, `halt`, `ssh`, `reload` and `provision` commands.
* Provision virtual machines with any built-in Vagrant provisioner.
* Synced folder support via `rsync`, `nfs` or `virtiofs`.

## Quick Start

* [Installation](/installation)
* [Configuration](/configuration)

## In case of problems

* [Troubleshooting](/troubleshooting)
