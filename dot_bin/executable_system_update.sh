#!/bin/bash

set -euo pipefail

prefix=''

if [[ "$EUID" -ne 0 ]]; then
  prefix='sudo '
fi

${prefix}pacman -Syyu --noconfirm --needed
yay -Sua --noconfirm --needed --answerdiff None --answeredit None
