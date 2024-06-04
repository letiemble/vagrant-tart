#!/usr/bin/env zsh
set -eo pipefail

# Run the virtual machine in the background with the arguments passed to the script
nohup tart run "$@" &

# Save the PID of the virtual machine
TART_VM_PID=$!

# Give the process 3 seconds to start.
sleep 3

# If the process is not alive, then exit with an error message
if ! ps -p $TART_VM_PID > /dev/null; then
  echo "Failed to start the virtual machine." 1>&2
  exit 1
fi
