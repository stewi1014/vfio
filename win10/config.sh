#!/bin/bash

CONNECT="qemu:///system"
DOMAIN="win10"
PIDFILE="/tmp/"$DOMAIN"_script.pid"
GPU=0000:08:00.0
GPU_AUDIO=0000:08:00.1

assert_sudo() {
    if [ $EUID -ne 0 ] || [ $UID -ne 0 ] && [ $UID -ne 1000 ]; then
        echo "Script requires sudo"
        exit 1
    fi
}
