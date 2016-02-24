#!/bin/sh

# helper functions
MPD_CUR="/dev/shm/mpd_current"
MPD_USE=0

mpd_current () {
	while :; do
		mpc current -f '[[%artist% - ]%title%]' > $MPD_CUR
		mpc idle
	done
}


# status getters
Swifi () {
	# requires some fancy stuff in netctl
	# to put name into /tmp/current-network
	cat /tmp/current-network
}

Smute () {
    if [ -n "$(amixer sget Master | grep off)" ]; then
        echo "_"
	else
		echo "#"
	fi
}

Sbat () {
	acpi | awk '{if ($3 != "Discharging,") { printf "+" } printf "%d%%\n", $4}'
}

Sdate () {
	date +"%D %R:%S"
}

Smpd () {
	if [ $MPD_USE = 0 ]; then
		mpd_current &
		MPD_USE=1
	fi

	cat $MPD_CUR
}

#super duper luper
while true
do
	stat=$(echo "$@" | sed 's/\([^ ]*\)/$(S\1)/g')
	stat="printf '%s\\n' \"$stat\""
	xsetroot -name "$(eval $stat)"
    sleep 1s;
done

