#!/bin/bash

set -euo pipefail

readonly TRACKPAD_ID='i2c-GXTP5100:00'


if [ -L "/sys/bus/i2c/drivers/i2c_hid_acpi/${TRACKPAD_ID}" ]; then
  echo "Disabling trackpad"
  echo "${TRACKPAD_ID}" | sudo tee /sys/bus/i2c/drivers/i2c_hid_acpi/unbind
else
  echo "Enabling trackpad"
  echo "${TRACKPAD_ID}" | sudo tee /sys/bus/i2c/drivers/i2c_hid_acpi/bind
fi
