#!/bin/bash

source $(dirname "$(realpath $0)")/config.sh
assert_sudo

# Run once after the stop of the vm as sudo

# echo 1 > /sys/bus/pci/devices/$GPU/remove
# echo 1 > /sys/bus/pci/devices/$GPU_AUDIO/remove
# rmmod vfio-pci
# echo 1 > /sys/bus/pci/rescan

systemctl set-property --runtime -- user.slice AllowedCPUs=0-31
systemctl set-property --runtime -- system.slice AllowedCPUs=0-31
systemctl set-property --runtime -- init.scope AllowedCPUs=0-31
