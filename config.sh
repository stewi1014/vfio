#!/bin/bash

CONNECT="qemu:///system"
DOMAIN="win10"
PIDFILE="/tmp/"$DOMAIN"_script.pid"
GPU=0000:08:00.0
GPU_AUDIO=0000:08:00.1

assert_root() {
    if [ $EUID -ne 0 ]; then
        echo "Script requires root"
        exit 1
    fi
}
