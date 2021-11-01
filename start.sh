#!/bin/bash

source $(dirname "$(realpath $0)")/config.sh
assert_sudo

# Run once before the start of the vm


systemctl set-property --runtime -- user.slice AllowedCPUs=0-7,16-23
systemctl set-property --runtime -- system.slice AllowedCPUs=0-7,16-23
systemctl set-property --runtime -- init.scope AllowedCPUs=0-7,16-23

# echo 1 > /sys/bus/pci/devices/$GPU/remove
# echo 1 > /sys/bus/pci/devices/$GPU_AUDIO/remove
# rmmod nvidia-drm nvidia-modeset nvidia
# modprobe vfio-pci
# echo 1 > /sys/bus/pci/rescan
