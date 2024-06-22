#!/usr/bin/env zsh
set -eo pipefail

HOST="$1"
USERNAME="$2"
PASSWORD="$3"

if [[ -z "$USERNAME" ]] || [[ -z "$PASSWORD" ]]; then
  # Assumes that the credentials are provided in another way (e.g. environment variables)
  tart login "$HOST"
else
  # Login to the registry with the provided credentials
  echo "$PASSWORD" | tart login "$HOST" --username "$USERNAME" --password-stdin
fi
