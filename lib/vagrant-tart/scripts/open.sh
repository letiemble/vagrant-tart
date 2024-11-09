#!/usr/bin/env zsh
set -eo pipefail

# Open a VNC connection to the virtual machine
nohup open $1 &
