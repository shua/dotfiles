#!/bin/sh

uniglyphs="$HOME/.config/uniglyphs.txt"
arg0=$0

gen() {
	nameslist='http://unicode.org/Public/9.0.0/ucd/NamesList.txt'

	uniglyph() {
		case $1 in
		00[0-7][0-9A-F])
			n=$(printf "%02x" 0x$1)
			g=$(printf "\x$n")
			;;
		[0-7A-F][0-7A-F][0-7A-F][0-7A-F])
			g=$(printf "\u$1")
			;;
		*)
			n=$(printf "%08x" 0x$1)
			g=$(printf "\U$n")
			;;
		esac
	#	g=$(echo "\u$1");
		shift;
		echo "$g" $@;
	}

	curl "$nameslist" \
		|grep "^[0-9A-F]"  |grep -v "<*>" \
		|(while read l; do uniglyph $l; done) >$uniglyphs
}

sel() {
	if [ ! -r $uniglyphs ]; then
		echo "ERROR: uniglyphs file must be generated first with" >&2
		echo "	$(basename $arg0) gen" >&2
		exit
	fi

	cat $uniglyphs |bemenu -i -l 10 -fn "monospace:size=16" |awk '{printf "%s", $1}'
}

case $1 in
-h|help)
	printf "usage: uniglyph [gen|sel]\n"
	;;
gen)
	gen
	;;
sel)
	sel
	;;
*)
	sel |wl-copy -t 'text/plain'
	;;
esac

