#!/bin/sh

statusline "$@" |while read line; do
	xsetroot -name "$line"
done

