#!/bin/mksh

del=''$'\x7f'
nl=''$'\x0a'
esc=''$'\x1b'
eot=''$'\x04'
nak=''$'\x15'

kup=''$esc'[A'
kdn=''$esc'[B'
klf=''$esc'[C'
krt=''$esc'[D'

clearline=''$esc'[2K'

editline() {
	oIFS="$IFS"
	line=""
	i=0

	ctrlchars="$(for i in $(seq 0 31) 127; do ix=$(printf "%02x" $i); printf "\x${ix}"; done)"

	stty -echo
	while :; do
		IFS=""
		read -n4 c;
		IFS="$oIFS"

		case "$c" in
		"$del")
			line="${line%?}"
			[ $i -gt 0 ] && i=$((i-1))
			printf "$clearline"
			;;
		"$nl")
			printf "$clearline"
			printf "${line}\n" >&3
			i=0
			line=""
			;;
		"$nak")
			printf "$clearline"
			printf "${line}\n" >&3
			i=0
			line=""
			;;
		"$eot")
			printf "\n"
			return
			;;
		[$ctrlchars]*)
			;;
		?)
			line="${line}${c}"
			i=$((i+1))
			;;
		esac

		cols=$(tput cols)
		printf "\r%3d " $i
		if [ $((i+4)) -gt $cols ]; then
			printf '<'
			printf '%s' "${line}" |sed 's/.*\(.\{'$((cols-5))'\}\)/\1/g'
		else
			printf '%s' "${line}"
		fi
	done
	stty echo
}

bgprint() {
	sed 's/.*/\r'"${clearline}"'> &/g' <&4 &
	echo $!
}

run1() {
	if [ "$2" = "-" ]; then
		exec 3>&1
	else
		exec 3>$2
	fi
	#editline
	#exit
	#epid=$!


	if [ -p "$1" ]; then
		echo "pipe" >&2
		exec 4<$1
	else
		echo "file:" $1 >&2
		pipe=$(mktemp -u)
		echo "pipe:" $pipe >&2
		mkfifo $pipe
		echo "fifo:" $pipe >&2
		exec 4<>$pipe
		echo "exec" >&2
		tail -f $1 --pid=$$ >&4 &
		bpid=$!
		echo "done: $bpid" >&2
	#	rm $pipe
	#	tail -f $1 --pid=$$ |sed 's/.*/\r'"${clearline}"'&/g' >/dev/tty &
	fi
	#bpid="$bpid $(bgprint) $(echo done >&2)"
	echo "pids: ${epid}, ${bpid}" >&2
	bpid=$(bgprint &)
	bgprint
	echo "pids: ${epid}, ${bpid}" >&2

	#leave() { 
	#	trap exit SIGTERM
	#	exit
	#}
	#trap leave SIGINT SIGTERM

	wait $epid
	kill $bpid
}

run2() {
	if [ ! "${ppid}" ]; then
		echo "parent pid must be set or annoyance..." >&2
		return
	fi

	tail -f $1 --pid=${ppid} |sed 's/.*/\r'"${clearline}"'&/g' >/dev/tty &
	editline
}


arg0=$(basename $0)
ppid=$$
if [ $# -lt 1 ]; then
	echo "usage: ${arg0} INFILE [OUTFILE]"
	exit
fi
if [ $# -eq 1 ]; then
	exec 3>&1
	exec 1>/dev/tty
else
	exec 3>$2
fi

run2 $@

