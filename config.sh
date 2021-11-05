#!/bin/bash

export CONNECT="qemu:///system"
export DOMAIN="win10"
export PIDFILE="/tmp/${DOMAIN}_script.pid"
export GPU=0000:0b:00.0
export GPU_AUDIO=0000:0b:00.1

assert_root() {
    if [ $EUID -ne 0 ]; then
        echo "Script requires root"
        exit 1
    fi
}
