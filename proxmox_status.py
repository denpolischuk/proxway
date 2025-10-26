#!/usr/bin/env python3
import json
import os
import sys
from proxmoxer import ProxmoxAPI

TIME_DURATION_UNITS = (
    ('day', 60*60*24),
    ('hour', 60*60),
    ('min', 60),
    ('sec', 1)
)

# ====== CONFIG ======
PROXMOX_HOST = os.getenv("PROXMOX_HOST")
API_USER = os.getenv("PROXMOX_USER")
API_TOKEN_NAME = os.getenv("PROXMOX_TOKEN_NAME")
API_TOKEN_VALUE = os.getenv("PROXMOX_TOKEN_VALUE")
# ====================

try:
    proxmox = ProxmoxAPI(
        PROXMOX_HOST,
        user=API_USER,
        token_name=API_TOKEN_NAME,
        token_value=API_TOKEN_VALUE,
        verify_ssl=False
    )
except Exception as e:
    print(json.dumps({
        "text": "Proxmox API error",
        "tooltip": str(e)
    }))
    sys.exit(0)


def human_time_duration(seconds, omit=[]):
    if seconds == 0:
        return 'inf'
    parts = []
    for unit, div in TIME_DURATION_UNITS:
        if unit in omit:
            continue
        amount, seconds = divmod(int(seconds), div)
        if amount > 0:
            parts.append('{} {}{}'.format(
                amount, unit, "" if amount == 1 else "s"))
    return ', '.join(parts)


# When clicked with --details, show popup list
if len(sys.argv) > 1 and sys.argv[1] == "--details":
    from subprocess import run
    import textwrap

    nodes = proxmox.nodes.get()
    lines = []
    for node in nodes:
        name = node["node"]
        status = node["status"]
        node_status_icon = "🟢" if status == "online" else "🔴"
        lines.append(f"{name}\t{node_status_icon}\tUp: {
                     human_time_duration(node['uptime'])}")
        try:
            # List containers on this node
            containers = proxmox.nodes(name).lxc.get()
            if len(containers) > 0:
                lines.append("Containers: ")
                for idx, ct in enumerate(containers):
                    container_status_icon = "🟢" if ct['status'] == "running" else "🔴"
                    ipv4 = "?"
                    # Get network interfaces and filter for eth0
                    net_info = [interface for interface in proxmox.nodes(name).lxc(
                        ct['vmid']).interfaces.get() if interface['name'] == 'eth0']
                    if net_info[0]:
                        inf = net_info[0]
                        ipv4 = inf['inet'] if inf['inet'] else "?"
                    lines.append(f"{idx+1}. {ct['name']:<9}\t{
                        container_status_icon}\t{ipv4}\tUp: {human_time_duration(ct['uptime'], ['min', 'sec'])}")
        except Exception:
            lines.append(
                f"{name:<10} {node_status_icon} (no access or offline)")

    msg = "\n".join(lines)
    run(["notify-send", "Proxmox Hosts", msg])
    sys.exit(0)

# Compact status for Waybar
nodes = proxmox.nodes.get()
statuses = ["🟢" if n["status"] == "online" else "🔴" for n in nodes]
up = statuses.count("🟢")
down = statuses.count("🔴")

if len(nodes) > 3:
    summary = "".join(statuses[:3]) + f" +{len(nodes)-3}"
else:
    summary = "".join(statuses)

out = {
    "text": f"🖥️ {summary}",
    "tooltip": f"Proxmox: {up} online, {down} offline",
    "class": "custom-proxway"
}

print(json.dumps(out))
