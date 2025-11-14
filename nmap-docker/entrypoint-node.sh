#!/bin/bash
set -e

# optional gateway set by docker-compose environment
GATEWAY=${GATEWAY:-}

# set hostname from container name (if available)
if [ -n "$HOSTNAME" ]; then
  hostnamectl set-hostname "$HOSTNAME" || true
fi

# start sshd
if [ -x "$(command -v /usr/sbin/sshd)" ]; then
  /usr/sbin/sshd
fi

# If gateway specified, set default route (useful for simulation)
if [ -n "$GATEWAY" ]; then
  # delete existing default route and add gateway
  ip route del default || true
  ip route add default via "$GATEWAY"
fi

# Start some simple TCP listeners so nmap scans show open ports
# port 9001 returns a banner
nohup ncat -l -k -p 9001 -c 'echo "Hello from $(hostname) on port 9001"' >/dev/null 2>&1 &
# port 9002 keeps a shell echo
nohup ncat -l -k -p 9002 -c 'while read l; do echo "You said: $l"; done' >/dev/null 2>&1 &

# keep container alive
tail -f /dev/null
