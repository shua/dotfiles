#!/bin/sh

# helper functions
NET_CUR="/tmp/current-network"
MPD_CUR="/dev/shm/mpd_current"
Impd () {
	while :; do
		mpc >/dev/null 2>&1
		while [ $? -eq 0 ] ; do
			mpc current -f '[[%artist% - ]%title%]' > "$MPD_CUR"
			mpc idle >/dev/null
		done
		echo "" > "$MPD_CUR"
	sleep 10
	done &
}

# status getters
Swifi () {
	# requires some fancy stuff in netctl
	# to put name into /tmp/current-network
	cat "$NET_CUR" 
}

Smute () {
    if [ -n "$(amixer sget Master | grep off)" ]; then
        echo "M"
	fi
}

Sbat () {
	acpi | awk '{if ($3 != "Discharging,") { printf "+" } printf "%d%%\n", $4}'
}

Sdate () {
	date +"%D %R:%S"
}

Smpd () {
	[ -r "$MPD_CUR" ] && cat "$MPD_CUR" || return 0
}

#super duper luper
for a in $@; do
	i="I$a"
	(type $i >/dev/null 2>&1) && $i
done

while true
do
	# this could be done with a sed and eval
	# replacing all a with $(S$a) but this seems better
	# I haven't noticed a slowdown except when I used
	# type "S$a" so I don't use that
	stat=""
	for a in $@; do
		s="S$a"
		sret="$($s 2>/dev/null)"
		if [ $? -eq 0 ]; then
			[ -n "$sret" ] && stat="${stat} ${sret}"
		else
			stat="${stat} $a"
		fi
	done
	xsetroot -name "$stat"
    sleep 1s;
done

