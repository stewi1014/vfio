#!/bin/bash

# Run once before the start of the vm

source $(dirname "$(realpath $0)")/config.sh
assert_root

# Block Linux from using half the CPU.
systemctl set-property --runtime -- user.slice AllowedCPUs=0-7,16-23
systemctl set-property --runtime -- system.slice AllowedCPUs=0-7,16-23
systemctl set-property --runtime -- init.scope AllowedCPUs=0-7,16-23
