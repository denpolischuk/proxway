# Proxway - simple proxmox status tracker for Waybar

## Description
This is a simple tool to track proxmox hosts and their lxc containers from Waybar.
It shows statuses of up to 3 hosts (🟢 up or 🔴 down) and on click it sends a notification with more detailed data per host and their LXC containers.

## Installation
1. Create a proxmox API token that has access to hosts, lxc and nw interfaces.
2. Clone this repo 
```bash
git clone git@github.com:denpolischuk/proxway.git "$XDG_CONFIG_HOME/waybar/proxway"
```
3. Run installation script and follow the script instructions
```bash
cd "$XDG_CONFIG_HOME/waybar/proxway"
./install.sh
```

