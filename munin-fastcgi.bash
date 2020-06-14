apt-get install spawn-fcgi libcgi-fast-perl

nano /etc/init.d/munin-fastcgi

#! /bin/sh

### BEGIN INIT INFO
# Provides: spawn-fcgi-munin-graph
# Required-Start: $all
# Required-Stop: $all
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: starts FastCGI for Munin-Graph
### END INIT INFO
# ————————————————————–
# Munin-CGI-Graph Spawn-FCGI Startscript by Julien Schmidt
# eMail: munin-trac at julienschmidt.com
# www: http://www.julienschmidt.com
# ————————————————————–
# Install:
# 1. Copy this file to /etc/init.d
# 2. Edit the variables below
# 3. run „update-rc.d spawn-fcgi-munin-graph defaults”
# ————————————————————–
# Special thanks for their help to:
# Frantisek Princ
# Jérôme Warnier
# ————————————————————–
# Last Update: 14. February 2013
#
# Please change the following variables:

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
NAME=spawn-fcgi-munin-graph
PID_FILE=/var/run/munin/$NAME.pid
SOCK_FILE=/var/run/munin/$NAME.sock
SOCK_USER=www-data
FCGI_USER=www-data
FCGI_GROUP=www-data
FCGI_WORKERS=2
DAEMON=/usr/bin/spawn-fcgi
DAEMON_OPTS=”-s $SOCK_FILE -F $FCGI_WORKERS -U $SOCK_USER -u $FCGI_USER -g $FCGI_GROUP -P $PID_FILE — /usr/lib/munin/cgi/munin-cgi-graph”

# ————————————————————–
# No edits necessary beyond this line
# ————————————————————–

if [ ! -x $DAEMON ]; then
echo „File not found or is not executable: $DAEMON!”
exit 0
fi

status() {
if [ ! -r $PID_FILE ]; then
return 1
fi

for FCGI_PID in `cat $PID_FILE`; do
if [ -z „${FCGI_PID}” ]; then
return 1
fi

FCGI_RUNNING=`ps -p ${FCGI_PID} | grep ${FCGI_PID}`
if [ -z „${FCGI_RUNNING}” ]; then
return 1
fi
done;

return 0
}

start() {
if status; then
echo „FCGI is already running!”
exit 1
else
$DAEMON $DAEMON_OPTS
fi
}

stop () {
if ! status; then
echo „No PID-file at $PID_FILE found or PID not valid. Maybe not running”
exit 1
fi

# Kill processes
for PID_RUNNING in `cat $PID_FILE`; do
kill -9 $PID_RUNNING
done

# Remove PID-file
rm -f $PID_FILE

# Remove Sock-File
rm -f $SOCK_FILE
}

case „$1” in
start)
echo „Starting $NAME: ”
start
echo „… DONE”
;;

stop)
echo „Stopping $NAME: ”
stop
echo „… DONE”
;;

force-reload|restart)
echo „Stopping $NAME: ”
stop
echo „Starting $NAME: ”
start
echo „… DONE”
;;

status)
if status; then
echo „FCGI is RUNNING”
else
echo „FCGI is NOT RUNNING”
fi
;;

*)
echo „Usage: $0 {start|stop|force-reload|restart|status}”
exit 1
;;
esac

exit 0