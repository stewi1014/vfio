#!/bin/bash

src=$(dirname "$(realpath $0)")
source $src/config.sh

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

# Run once for every lone stop of the script (does not run if another instance is running)
script_exit() {
	wait_exit
	sudo -A -s $src/stop.sh
	rm -rf $PIDFILE
}

# Main
if script_unique; then
	echo $$ >$PIDFILE
	if [ $? -ne 0 ]; then
		echo "Could not create PID file"
		exit 1
	fi

	if is_running; then
		echo "VM already running"
	else
		sudo -A -s $src/start.sh
		virsh --connect=$CONNECT start $DOMAIN
	fi

	trap script_exit EXIT
fi

$src/display.sh
