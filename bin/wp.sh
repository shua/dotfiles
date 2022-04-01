#!/bin/sh

if [ -n "$1" ]; then
    if [ -e "$1" ]; then
        wp="$1"
    elif [ -e ~/pic/wp/$1 ]; then
        wp=~/pic/wp/$1
    else
        echo "error: $1 not found" >&2
        exit
    fi
else
    wp=~/pic/wp/$(ls ~/pic/wp/ |shuf |head -n1)
fi

# swaymsg "output * bg $wp fill"
swaybg -i $wp -m fill

