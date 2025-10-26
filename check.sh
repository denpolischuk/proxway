#!/usr/bin/env bash

set -e

# --- Check Python ---
if ! command -v python3 >/dev/null 2>&1; then
  echo "Python3 is not installed. Please install it first."
  exit 1
fi

if ! command -v pip3 >/dev/null 2>&1; then
  echo "pip3 is not installed. Please install it (e.g. sudo apt install python3-pip)."
  exit 1
fi
