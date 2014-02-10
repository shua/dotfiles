#
# ~/.bashrc
#

# If not running interactively, don"t do anything
[[ $- != *i* ]] && return

alias ls="ls --color=auto"
alias jdbr="java -Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n"
alias jdbc="jdb -connect com.sun.jdi.SocketAttach:hostname=localhost,port=8000"
export WLANRTL="wlp0s26u1u4i2"
PATH="$PATH:/home/shua/bin"
export EDITOR="vim"
export BROWSER="chromium"

function mono_prompt {
local LBK="\[\e[38;5;8m\]"
local BK="\[\e[38;5;0m\]"
local RD="\[\e[38;5;1m\]"
local OG="\[\e[38;5;6m\]"
local YW="\[\e[38;5;3m\]"
local GN="\[\e[38;5;2m\]"
local BL="\[\e[38;5;4m\]"
local VL="\[\e[38;5;5m\]"
local RST="\[\e[0m\]"


PS1="$LBK[$RD\u$YW@$GN\h $BL\w$LBK]\$ $RST"
PS2="$VL> $RST"
}

mono_prompt

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

