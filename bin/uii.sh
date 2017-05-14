#!/bin/sh

IRCPATH=~/irc

snick() {
	# make nickname for server
	arg0="${arg0} snick"
	if [ $# -lt 2 ]; then
		echo "usage: ${arg0} <serv> <snick>"
		return
	fi
	serv=$1
	nick=$2
	echo ${serv} ${nick}

	mv ${IRCPATH}/${serv} ${IRCPATH}/${nick}
	ln -s ${nick} ${IRCPATH}/${serv}
}

io() {
	# start ioline prompt
	arg0="${arg0} io"
	if [ $# -lt 1 ]; then
		echo "usage: ${arg0} <serv>[/[<chan>]]"
		return
	fi
	path=${IRCPATH}/$1
	case ${path} in
	*/)
		chan=$(cd ${path}; ls -d */ |cut -d'/' -f1 |slmenu)
		if [ ! "${chan}" ]; then
			return
		else
			path=${path}${chan}
		fi
		;;
	esac

	echo ${path}
	timeout 1 sh -c "printf '' >${path}/in"
	if [ $? -ne 0 ]; then
		echo "${path} doesn't seem to be open"
		return
	fi

	ioline ${path}/out ${path}/in
}

serv() {
	arg0="${arg0} serv"
	if [ $# -lt 1 ]; then
		echo "usage: ${arg0} <serv> [<ii args>]"
		echo "       ${arg0} {start,list,kill}"
		return
	fi

	arg1=$1
	shift
	case "${arg1}" in
	start)
		servstart $@
		;;
	list)
		servlist $@
		;;
	kill)
		servkill $@
		;;
	*)
		ii -s ${arg1} $@ &
		;;
	esac
}

servstart() {
	serv=$(cd ${IRCPATH}; ls -d */ |cut -d'/' -f1 |grep -E "[^.]+\..+" |slmenu)
	if [ "${serv}" ]; then
		ii -s ${serv} $@ &

		auto=${IRCPATH}/${serv}/auto
		if [ -r ${auto} ]; then
			echo "auto exists"
			cat ${auto} >${IRCPATH}/${serv}/in
		fi
	fi
}

servlist() {
	ps xo comm,pid,args |awk '/^ii/{$1=""; $0=$0; $1=$1; print}'
}

servkill() {
	sel=$(servlist |slmenu)
	if [ ! "${sel}" ]; then
		return
	fi

	kill -HUP $(echo "$sel" |cut -d' ' -f1)
}

arg0=$(basename $0)
cmd=$1
shift
case $cmd in
snick)
	snick $@
	;;
io)
	io $@
	;;
serv)
	serv $@
	;;
list)
	serv list $@
	;;
start)
	serv start $@
	;;
kill)
	serv kill $@
	;;
*)
	echo "usage: ${arg0} {io,snick,serv} ..."
esac

