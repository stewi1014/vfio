#!/bin/bash

# Run once after the stop of the vm as root

source $(dirname "$(realpath $0)")/config.sh
assert_root

# Allow Linux to use all CPU cores.
systemctl set-property --runtime -- user.slice AllowedCPUs=0-31
systemctl set-property --runtime -- system.slice AllowedCPUs=0-31
systemctl set-property --runtime -- init.scope AllowedCPUs=0-31
