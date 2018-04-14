#!/bin/sh

if [ ! -z "$1" ]; then
    if [ -e "$1" ]; then
        wp="$1"
    elif [ -e ~/pic/wp/$1 ]; then
        wp=~/pic/wp/$1
    else
        echo "error: $1 not found"
        exit
    fi
else
    wp=~/pic/wp/$(ls ~/pic/wp/ |shuf |tail -n1)
fi

hsetroot -fill $wp