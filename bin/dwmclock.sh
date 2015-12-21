#!/bin/sh
while true
do
    if [ -n "$(amixer sget Master | grep off)" ]; then
        mute="M "
    else
        mute=""
    fi
    xsetroot -name "$(cat /tmp/current-network) ${mute}$(acpi | awk '{printf "%d%%\n", $4}') $(date +"%D %R:%S")"
    sleep 1s;
done

