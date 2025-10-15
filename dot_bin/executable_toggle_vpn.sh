#!/bin/bash



# Toggle the wireguard vpn connection wg0
#
#

# Check if the vpn is up
if [ -z "$(sudo wg show wg0)" ]; then
  # Start the vpn
  sudo wg-quick up wg0
  sudo ip route add 151.101.0.0/16 via 192.168.2.1
  sudo ip route add 146.75.0.0/16 via 192.168.2.1
else
  # Stop the vpn
  sudo wg-quick down wg0
  sudo ip route del 151.101.0.0/16 via 192.168.2.1
  sudo ip route del 146.75.0.0/16 via 192.168.2.1
fi

sudo wg show wg0
