---
title: Using with Ansible Molecule
nav_order: 5
---

[Ansible Molecule](https://ansible.readthedocs.io/projects/molecule/) is a testing framework for Ansible roles and playbooks.

You can use Tart virtual machines in Molecule by setting the `provider` to `tart` in the `molecule.yml` file.
Here is an example of a `molecule.yml` file that uses a Tart virtual machine:

```yaml
---
dependency:
  name: galaxy
driver:
  name: vagrant
  provider:
    name: tart
lint: |
  yamllint -f parsable .
  flake8
  ansible-lint
platforms:
  - name: instance
    cpus: 4
    memory: 4096
    instance_raw_config_args:
      - "ssh.username = 'admin'"
      - "ssh.password = 'admin'"
    config_options:
      synced_folder: false
    provider_options:
      image: ghcr.io/cirruslabs/macos-sonoma-vanilla:latest
      name: molecule
provisioner:
  name: ansible
  inventory:
    links:
      group_vars: inventories/group_vars
      host_vars: inventories/host_vars
  config_options:
    ssh_connection:
      pipelining: true
scenario:
  name: default
verifier:
  name: testinfra
  options:
    junit-xml: tests/junit.xml
    rootdir: .
    v: 1
```
