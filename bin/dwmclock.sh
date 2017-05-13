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
red_shift_m1="06"
red_shift_m0="07"
red_shift_n1="19"
red_shift_n2="20"
red_shift_n3="22"
red_shift () {
	hour=$(date +"%H")
	if [ x$hour = x$red_shift_h ]; then
		return
	fi
	red_shift_h=$hour

	if [ $hour -gt $red_shift_n1 ]; then
		if [ $hour -lt $red_shift_n2 ]; then
			sct 3000
		elif [ $hour -lt $red_shift_n3 ]; then
			sct 2000
		else
			sct 1000
		fi
	elif [ $hour -le $red_shift_m0 ]; then
		if [ $hour -le $red_shift_m1 ]; then
			sct 1000
		else
			sct 2000
		fi
	else
		sct
	fi
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

