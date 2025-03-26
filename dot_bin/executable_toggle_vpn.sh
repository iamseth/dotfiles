#!/bin/bash

# Toggle the wireguard vpn connection wg0

# Check if the vpn is up
if [ -z "$(sudo wg show wg0)" ]; then
  # Start the vpn
  sudo wg-quick up wg0
  zenity --notification --text="VPN is now connected"
else
  # Stop the vpn
  sudo wg-quick down wg0
  zenity --notification --text="VPN is now disconnected"
fi

sudo wg show wg0

