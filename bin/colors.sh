#!/bin/sh

for mod in {0..7}; do 
    for color in {30..37}; do 
        echo -en "\e[${mod};${color}m ${mod};${color}m \t\e[0m"
    done
    echo
done
for back in {40..47}; do 
    for color in {30..37}; do 
        echo -en "\e[${back};${color}m ${back};${color}m \e[0m"
    done
    echo
done;
