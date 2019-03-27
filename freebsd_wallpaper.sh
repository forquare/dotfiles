#!/bin/sh

if [ -n $2 ] && [ $2 -gt 0 ]; then
    sleep_time=$2
else
    sleep_time=5
fi

if which feh > /dev/null 2>&1 && [ -d "$1" ]; then
    while :; do
        feh -z --bg-fill "$1"
        sleep $sleep_time
    done
fi
