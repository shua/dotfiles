#!/bin/sh

gii_child3() {
	cat $1/out |grep -E "quit|shua|$" --color=always >&3
}

gii_child2() {
#	(cat $1/out; tail -n1 -f $1/out) |grep -E "quit|shua|$" --color=always >&3
#	cat $1/out |grep -E "quit|shua|$" --color=always >&3
	tail -f $1/out --pid=$$ |grep -E "quit|shua|$" --color=always
}

gii_child() {
	for i in $(seq 10); do
		echo $i >&3
		sleep 1
	done
}

gii2() { 
	pipe1=$(mktemp -u)
	mkfifo ${pipe1}
#	echo $pipe1
	exec 3<>${pipe1}
	rm $pipe1

	gii_child2 $1 >&3 2>/dev/null &
	cpid=$!
#	echo $cpid
	
	<&3 ioline - - >$1/in
	echo "done?"
#	<&3 ~/dvl/test >$1/in
	disown $cpid
#	kill $cpid
	3<&-
}

gii1() {
	pipe1=$(mktemp -u)
	mkfifo ${pipe1}
	echo $pipe1
	exec 3<>${pipe1}
	trap "rm $pipe1; exit" INT

	tail -f $1/out --pid=$$ |grep -E "quit|shua|$" --color=always >&3 &
	ioline ${pipe1} $1/in
	rm $pipe1
}

gii0() {
	ioline $1/out $1/in
}


if [ $# -lt 1 ]; then
	echo "usage: $(basename $0) PATH"
	exit
fi
gii0 $@
