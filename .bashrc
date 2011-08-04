
# Check for an interactive session
[ -z "$PS1" ] && return

function myne
{

local BLUE="\[\e[0;34m\]"
local BROWN="\[\e[0;33m\]"
local GREEN="\[\e[0;32m\]"
local NOCOL="\[\e[0m\]"

PS1="$BLUE[$BROWN\u@\h $BLUE-$BROWN \w$BLUE]\n$BLUE[$GREEN\t$BLUE]$BROWN \$ $NOCOL"
}

function myne2
{
PS1='\[\e[0;34m\][\[\e[0;33m\]\u@\h \[\e[0;34m\] - \[\e[0;33m\]\w\[\e[0;34m\]] \n\[\e[0;34m\][\[\e[0;32m\]\t\[\e[0;34m\]]\[\e[0;33m\] \$\[\e[0m\] '
}

myne

alias ls='ls --color=auto'

EDITOR=/usr/bin/nano
PATH=/home/shua/bin:/usr/local/bin:/usr/local/sbin:$PATH
