#!/bin/bash

# Run once before the start of the vm as root

source "$(dirname "$(realpath "$0")")/config.sh"
assert_root

# List all processes using the nvidia GPU.
# Example of format;
# xembedsni 1140 stewi    1w   CHR     1,3      0t0    4 /dev/null
# gmenudbus 1239 stewi    1w   CHR     1,3      0t0    4 /dev/null
# pulseaudi 1245 stewi  mem    CHR  116,25           751 /dev/snd/pcmC3D0p
nvidia_procs=$(lsof +D /dev | grep nvidia)

# If a process was found (non zero exit code), show error and exit.
if [ -n "$nvidia_procs" ]; then
    # Format the list of processes using the nvidia GPU into a newline-seperated list of unique PIDs.
    pids=$(echo "$nvidia_procs" | awk 'NR>1 {a[$2]++}!(a[$2]-1){print $2}')

    echo "Cannot start; pids using the GPU:"
    echo "$pids"

    ## $ps
    # Get the process' command (and re-print the pids)

    ## | awk
    # Turn it into a newline-seperated list of PIDs and commands (alternating between PID and command)
    # Example of format;
    # 1140
    # /usr/bin/xembedsniproxy
    # 1239
    # /usr/bin/gmenudbusmenuproxy
    # 1245
    # /usr/bin/pulseaudio --daemonize=no --log-target=journal

    ## | zenity
    # Create a notification showing the processes using the GPU

    ps --no-headers -o pid,cmd $pids \
        | awk 'sub(/^[ \t]+/, ""){sub(FS,RS)}1' \
        | zenity --list --title "Cannot unbind GPU" --text="Processes currently using the GPU" --column="PID" --column="Command"

    exit 1
fi

# Block Linux from using half the CPU.
systemctl set-property --runtime -- user.slice AllowedCPUs=0-7,16-23
systemctl set-property --runtime -- system.slice AllowedCPUs=0-7,16-23
systemctl set-property --runtime -- init.scope AllowedCPUs=0-7,16-23
