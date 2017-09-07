#!/bin/bash

## TomAshley303's process keepalive script for Linux. I have modified this to
## work with the squid-cache proxy server. Only need to set the process name
## to watch for and name of this script. Modify pgrep if not matching to your
## process's needs. Best to run with something like this:
## nohup sh keepAlive.sh > /dev/null 2>&1 &

# name of the daemon to watch
pname=squid
pstart=/usr/sbin/$pname

# this script
me=${0##*/}
# e.g. me=keepAlive.sh

export PATH=/bin:/usr/bin:/usr/sbin:/sbin

# sh sends SIGHUP on exit, we need to continue
trap 'echo "SIGHUP captured"' HUP

# no interactions, log all output and errors
mkdir -p /var/log
exec </dev/null >/var/log/${me%.*}.log 2>&1

# Solaris needs -z option
zopt=`{ zonename; } 2>/dev/null`
zopt=${zopt:+"-z $zopt"}

echo "$me started with pid $$"
sleep 3
# initiate the pid variables
pid=`pgrep $zopt -n -x $pname`
[ -n "$pid" ] || exec echo "no $pname process - exiting"
echo "$me watching $pname[$pid]"

# endless loop
while :
do
    sleep 30
    if [ \! -d /proc/$pid ]; then
        echo "`date` $me $pid is gone!"
        sleep 1
        echo "starting $pname"
        date
        eval $pstart
        sleep 3
        # renew the pid variables
        pid=`pgrep $zopt -x $pname`
        [ -n "$pid" ] || exec echo "no $pname process - exiting"
        echo "$me watching $pname[$pid]"
    fi
done 
