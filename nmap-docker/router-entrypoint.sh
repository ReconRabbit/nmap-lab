#!/bin/bash
set -e

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Clear any existing iptables rules (safe in this isolated lab)
iptables -F
iptables -t nat -F
iptables -X

# Allow forwarding between interfaces
iptables -P FORWARD ACCEPT

# (Optional) masquerade outbound when needed — here we don't NAT internal subnets to host
# but uncomment if you want NAT from net_a->net_b or vice versa:
# iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# Show interface and route information (for debug)
echo "=== IFCONFIG ==="
ip -br addr
echo "=== ROUTES ==="
ip route

# Keep container alive for debugging
tail -f /dev/null
