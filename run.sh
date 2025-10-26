#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --- Checking if python and pip are installed on the host
source "$SCRIPT_DIR/check.sh"

# --- Checking if proxmox config file was created
if [[ ! -f "$SCRIPT_DIR/proxmox_config.env" ]]; then
  echo "Proxmox config hasn't been initialized yet. Run install.sh first"
  exit 1
fi

# --- Exporting proxmox configs
source "$SCRIPT_DIR/proxmox_config.env"

# --- Running status check
python3 "$SCRIPT_DIR/proxmox_status.py" "$1" # $1 is to pass --details flag
