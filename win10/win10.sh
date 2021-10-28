#!/bin/bash

CONNECT="qemu:///system"
DOMAIN="win10"

PIDFILE="/tmp/"$DOMAIN"_script.pid"

is_running() {
	virsh --connect=$CONNECT domstate --domain=$DOMAIN | grep -q running
	return $?
}

wait_exit() {
	if is_running; then
		stdbuf -oL virsh --connect=qemu:///system event --domain=win10 --loop --event lifecycle | while read line; do
			if [[ "$line" == *"Stopped Shutdown"* ]]; then
				pkill -P $$ virsh
				break
			fi
		done
	fi
}

# Run once before the start of the vm
start() {
	echo "VM starting"

	sudo -A -s -- <<EOF

systemctl set-property --runtime -- user.slice AllowedCPUs=0-7,16-23
systemctl set-property --runtime -- system.slice AllowedCPUs=0-7,16-23
systemctl set-property --runtime -- init.scope AllowedCPUs=0-7,16-23

EOF
}

# Run once after the stop of the vm
stop() {
	echo "VM stopped"

	sudo -A -s -- <<EOF

systemctl set-property --runtime -- user.slice AllowedCPUs=0-31
systemctl set-property --runtime -- system.slice AllowedCPUs=0-31
systemctl set-property --runtime -- init.scope AllowedCPUs=0-31

EOF
}

# Run on every script execution
display() {
	looking-glass-client win:autoResize=yes input:escapeKey=100 input:rawMouse=yes
}

# Returns non-zero if script is running
script_unique() {
	if [ -f $PIDFILE ]; then
		PID=$(cat $PIDFILE)
		ps -p $PID >/dev/null 2>&1
		if [ $? -eq 0 ]; then
			return 1
		fi
		echo "Previous script exited uncleanly"
	fi
	return 0
}

# Run once for every lone start of the script (does not run if script is already running)
script_start() {
	echo $$ >$PIDFILE
	if [ $? -ne 0 ]; then
		echo "Could not create PID file"
		exit 1
	fi

	if is_running; then
		echo "VM already running"
	else
		start
		virsh --connect=$CONNECT start $DOMAIN
	fi
}

# Run once for every execution of the script
script_run() {
	display
}

# Run once for every lone stop of the script (does not run if script is already running)
script_exit() {
	wait_exit
	stop
	rm -rf $PIDFILE
}

# Main
if script_unique; then
	script_start
	trap script_exit EXIT
	script_run
else
	script_run
fi
