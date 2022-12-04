#!/bin/bash

# Run once for every execution of the script, irrelavent of VM status.

source "$(dirname "$(realpath "$0")")"/config.sh


looking-glass-client \
    input:escapeKey=54

#    win:autoResize=yes \
#    input:rawMouse=yes \
#    input:mouseSens=-5 \
#    input:grabKeyboardOnFocus=yes \
#    spice:captureOnStart \
#    win:fullScreen=yes \
#    egl:debug=yes

