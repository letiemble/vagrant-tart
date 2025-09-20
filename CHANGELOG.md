Here you can find the changelog for the project.

# [1.0.0] - 2025-09-20

- Bump version to 1.0.0, indicating the first stable release.
- Add support for `reboot` flag in shell provisioner.

# [0.0.7] - 2025-03-08

- Add ability to customize networking configuration.

# [0.0.6] - 2025-02-16

- Add `audio` option to the configuration file to enable audio. Audio is now disabled by default.
- Add `clipboard` option to the configuration file to enable clipboard sharing. Clipboard sharing is now disabled by default.
- Add `ip_resolver` option to the configuration file. The default is `dhcp`.
- Add `extra_run_args` option to the configuration file. This option allows you to pass additional arguments to the `tart run` command.

# [0.0.5] - 2024-11-09

- Add support for VNC access through the `vnc` command.

# [0.0.4] - 2024-06-22

- Add `suspendable` option to the configuration file.
- Make `username`/`password` optional when connecting to a private registry.

# [0.0.3] - 2024-06-08

- Rename `cpu` to `cpus` in the configuration file.

# [0.0.2] - 2024-06-05

- Initial release
