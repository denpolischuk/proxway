#!/usr/bin/env bash
set -e

echo "Installing Proxmox Waybar module..."

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --- Checking if python and pip are installed on the host
source "$SCRIPT_DIR/check.sh"

# --- Check for libnotify-bin ---
if ! command -v notify-send &> /dev/null; then
    echo "Error: libnotify-bin (notify-send) is not installed."
    echo "Please install libnotify-bin to enable desktop notifications."
    echo "On Debian/Ubuntu, you can install it with:"
    echo "  sudo apt-get install libnotify-bin"
    echo "On Fedora, you can install it with:"
    echo "  sudo dnf install libnotify"
    echo "On Arch Linux, you can install it with:"
    echo "  sudo pacman -S libnotify"
    exit 1
fi

# --- Install Python dependencies ---
REQ_FILE="$INSTALL_DIR/requirements.txt"
echo "Installing Python dependencies..."
echo "Next step will install Python packages from requirements.txt:"
echo "-------------------------------------------------------------"
cat "$REQ_FILE"
echo "-------------------------------------------------------------"
echo "These will be installed system-wide using:"
echo "  pip3 install --break-system-packages -r requirements.txt"
echo ""
read -rp "Do you want to proceed? [Y/n]: " install_pkgs

if [[ "$install_pkgs" =~ ^[Nn]$ ]]; then
    echo "Skipping package installation."
else
    echo "Installing Python dependencies..."
    pip3 install --break-system-packages -r "$REQ_FILE"
fi

# --- Ask for user configuration ---
echo ""
echo "Let's configure your Proxmox connection."
read -rp "Enter your Proxmox host (IP or FQDN): " proxmox_host
read -rp "Enter your Proxmox API user (e.g. root@pam): " proxmox_user
read -rp "Enter your Proxmox API token name: " proxmox_token_name

echo ""
echo "Now, enter your Proxmox API token value."
read -rsp "API token value: " proxmox_token_value
echo ""
echo ""

# --- Create config template ---
CONFIG_FILE="$SCRIPT_DIR/proxmox_config.env"

cat > "$CONFIG_FILE" <<EOF
# Proxmox Waybar Config Template
export PROXMOX_HOST="${proxmox_host}"
export PROXMOX_USER="${proxmox_user}"
export PROXMOX_TOKEN_NAME="${proxmox_token_name}"
export PROXMOX_TOKEN_VALUE="${proxmox_token_value}"
EOF

# --- Reminder for user ---
echo "Configuration file created at: $CONFIG_FILE"
echo "You can now add the Waybar module to your config:"
cat <<'EOF'
    "custom/proxway": {
        "exec": "<Path to the script>/proxway/run.sh",
        "interval": 60,
        "return-type": "json",
        "on-click": "<Path to the script>/proxway/run.sh --details",
        "tooltip": false
    }
EOF
