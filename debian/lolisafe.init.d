#!/bin/sh
### BEGIN INIT INFO
# Provides:          lolisafe
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description: 	     lolisafe service script
### END INIT INFO

# Author: RyoshiKayo <kayo@kayo.moe>

SCRIPT=/usr/share/lolisafe/lolisafe.js
RUNAS=lolisafe
NODE=/usr/share/lolisafe/node/bin/node

PIDFILE=/var/run/lolisafe.pid
LOGFILE=/var/log/lolisafe.log

start() {
	local is_running=$(pgrep -F "$PIDFILE" &> /dev/null)
	if [ $? -ne 0 ] && [ -f "$PIDFILE" ]
	then
		echo "Lolisafe is already running!" >&2
		return 1
	fi
	echo "Starting lolisafe..." >&2
	echo "Starting lolisafe!" >> "$LOGFILE"
	local CMD="cd /usr/share/lolisafe && $NODE $SCRIPT > $LOGFILE 2>&1 &"
	su -c "$CMD" "$RUNAS" 
	echo $! > "$PIDFILE"
	echo "Lolisafe started! $(cat $PIDFILE)" >&2
}

stop() {
	if [ ! -e "$PIDFILE" ]
	then
		echo "Lolisafe is not running (no pidfile)!" >&2
		return 0
	fi

	local is_running=$(pgrep -F "$PIDFILE")
	if [ $? -eq 0 ] && [ ! -f "$PIDFILE" ]
	then
		echo "Lolisafe is not running!" >&2
		return 1
	fi
	echo "Shutting down lolisafe..." >&2
	echo "Stopping lolisafe" >> "$LOGFILE"
	kill -QUIT $(cat "$PIDFILE") || killall -u lolisafe && rm -f "$PIDFILE"
	echo "Lolisafe stopped" >&2
}

uninstall() {
	echo -n "Are you really sure you want to uninstall this service? This cannot be undone. [y/n] "
	local SURE
	read SURE
	if [[ ! "$SURE" =~ "y" ]]
	then
		echo "NOT uninstalling lolisafe service." >&2
		return 0
	fi
	force_uninstall
}

force_uninstall() {
	stop
	rm -f "$PIDFILE"
	update-rc.d -f lolisafe remove
	rm -fv "$0"
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	uninstall)
		uninstall
		;;
	force-uninstall)
		force_uninstall
		;;
	restart)
		start
		stop
		;;
	*)
		echo "Usage: $0 {start|stop|restart|uninstall}"
esac
