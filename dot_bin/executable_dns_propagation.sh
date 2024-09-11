#!/bin/bash
# This script checks the DNS propagation of a domain name

set -euo pipefail

readonly GOOGLE='8.8.8.8 8.8.4.4'
readonly LEVEL3='4.2.2.1 4.2.2.2'
readonly QUAD9='9.9.9.9 149.112.112.112'
readonly CLOUDFLARE='1.1.1.1 1.0.0.1'
readonly OPENDNS='208.67.222.222 208.67.220.220'
readonly NAMESERVERS="$GOOGLE $LEVEL3 $QUAD9 $CLOUDFLARE $OPENDNS"

echo $NAMESERVERS

for ns in $NAMESERVERS; do
  result=$(/usr/bin/dig +timeout=1 +noall +answer @"$ns" "$@")
  echo -en "$ns\n"
  echo -en "\t$result\n"
done
