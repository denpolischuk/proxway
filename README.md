# Proxway - simple proxmox status tracker for Waybar

## Description
This is a simple tool to track proxmox hosts and their lxc containers from Waybar.
It shows statuses of up to 3 hosts (🟢 up or 🔴 down).
<img width="128" height="32" alt="image" src="https://github.com/user-attachments/assets/380705c0-2862-41eb-bbac-e733935fa293" />

Clicking on it sends a notification with more detailed data per host and their LXC containers.
<img width="469" height="158" alt="image" src="https://github.com/user-attachments/assets/a6cb660f-add2-4d4f-87e6-b30c9757a29d" />


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

