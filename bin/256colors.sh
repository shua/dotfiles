#!/bin/sh

for color in {0..15}
    do echo -en "\e[38;5;${color}m ${color}\t\e[0m"
    if [ $((($color + 1) % 8)) == 0 ] 
        then echo 
    fi
done
for color in {16..231}
    do echo -en "\e[38;5;${color}m ${color}\t\e[0m"
    if [ $((($color + 1 - 16) % 6)) == 0 ] 
        then echo
    fi
done
for color in {232..256}
    do echo -en "\e[38;5;${color}m ${color}\e[0m"
done
echo
