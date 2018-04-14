#!/bin/sh

# helper functions
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
Snet () {
	ssid=$(wpa_cli list_networks |grep CURRENT |cut -f2)
	addr="$((ip a |grep "inet " |grep -v "127.0.0.1") >/dev/null 2>&1 && echo "+" || echo "")"
	echo "$addr$ssid"
}

Smute () {
    if [ -n "$(amixer sget Master | grep off)" ]; then
        echo "M"
	fi
}

Sbat () {
	cap="$(cat /sys/class/power_supply/BAT1/capacity)"
	status="$(cat /sys/class/power_supply/BAT1/status)"

	[ "$status" = "Discharging" ] || printf '+'
	printf '%d%%\n' "$cap"
}

Sdate () {
	date +"%D %R:%S"
}

Smpd () {
	[ -r "$MPD_CUR" ] && cat "$MPD_CUR" || return 0
}

red_shift_h=""
red_shift_c="
00:1000
06:2000
07:
19:3000
20:2000
21:1000
"
red_shift_a() {
	printf "%s:current\n%s" $red_shift_h "$red_shift_c"\
	|sort\
	|cut -d':' -f2\
	|grep -B1 current\
	|head -n1
}

red_shift () {
	hour=$(date +"%H")
	if [ x$hour = x$red_shift_h ]; then
		return
	fi
	red_shift_h=$hour

	sct $(red_shift_a)
}

#super duper luper
for a in $@; do
	i="I$a"
	(type $i >/dev/null 2>&1) && $i
done

while true; do
	# this could be done with a sed and eval
	# replacing all a with $(S$a) but this seems better
	# I haven't noticed a slowdown except when I used
	# type "S$a" so I don't use that
	stat=""
	for a in $@; do
		s="S$a"
		sret="$($s)"
		if [ $? -eq 0 ]; then
			[ -n "$sret" ] && stat="${stat} ${sret}"
		else
			stat="${stat} $a"
		fi
	done
	xsetroot -name "$stat"
	red_shift
    sleep 5s;
done

