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

cln=''$esc'[2K' #clearline

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
			printf "$cln"
			;;
		"$nl")
			printf "$cln"
			printf "${line}\n" >&3
			i=0
			line=""
			;;
		"$nak")
			printf "$cln"
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

run2() {
	if [ ! "${ppid}" ]; then
		echo "parent pid must be set or annoyance..." >&2
		return
	fi

	tail -f $1 --pid=${ppid} |sed 's/.*/\r'"${cln}"'&/g' >/dev/tty &
	editline
}


arg0=$(basename $0)
ppid=$$
if [ $# -lt 1 ]; then
	echo "usage: ${arg0} <infile> [<outfile>]"
	exit
elif [ $# -eq 1 ]; then
	exec 3>&1
	exec 1>/dev/tty
else
	exec 3>$2
fi

run2 $@
