#!/usr/bin/env zsh
set -eo pipefail

HOST="$1"
USERNAME="$2"
PASSWORD="$3"

# Login to the registry with the provided credentials
echo "$PASSWORD" | tart login "$HOST" --username "$USERNAME" --password-stdin
