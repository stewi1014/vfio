#!/bin/bash

# Run once for every execution of the script, irrelavent of VM status.

source "$(dirname "$(realpath "$0")")"/config.sh

looking-glass-client \
    win:autoResize=yes \
    input:escapeKey=54 \
    input:rawMouse=yes \
    input:mouseSens=-5 \
    egl:vsync=yes
