#!/bin/bash



if [ -L "/sys/bus/i2c/drivers/i2c_hid_acpi/i2c-SYNA802E:00" ]; then
  echo "Disabling trackpad"
  echo "i2c-SYNA802E:00" | sudo tee /sys/bus/i2c/drivers/i2c_hid_acpi/unbind
else
  echo "Enabling trackpad"
  echo "i2c-SYNA802E:00" | sudo tee /sys/bus/i2c/drivers/i2c_hid_acpi/bind
fi






#echo "i2c-SYNA802E:00" | sudo tee /sys/bus/i2c/drivers/i2c_hid_acpi/bind
