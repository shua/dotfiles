prepend_path() {
	case ":$PATH:" in
	*:"$1":*) ;;
	*:"$1")   ;;
	"$1":*)   ;;
	*)        PATH="$1${PATH:+:$PATH}"
	esac
}
append_path() {
	case ":$PATH:" in
	*:"$1":*) ;;
	*:"$1")   ;;
	"$1":*)   ;;
	*)        PATH="${PATH:+$PATH:}$1"
	esac
}
purge_path() {
	case ":$PATH:" in
	*:"$1":*) PATH="${PATH/:$1}";;
	*:"$1")   PATH="${PATH/:$1}";;
	"$1":*)   PATH="${PATH/$1:}";;
	esac
}

purge_path "/usr/bin/site_perl"
purge_path "/usr/bin/vendor_perl"
purge_path "/usr/bin/core_perl"
purge_path "$HOME/.nix-profile/bin"
# purge_path $HOME/.config/opam/*/bin
prepend_path "$HOME/bin"
prepend_path "$HOME/.local/bin"
append_path "$HOME/.cargo/bin"
append_path "$HOME/.elan/bin"

export EDITOR=/usr/lib/helix/hx
export BROWSER=firefox
export CC=clang
export CPP="clang -E"
export CXX="clang++"
export GIMP2_DIRECTORY=$HOME/.config/gimp
export GNUPGHOME=$HOME/.config/gnupg
export MOZ_ENABLE_WAYLAND=1
export HELIX_RUNTIME=$HOME/.config/helix/runtime
export GOPATH=$HOME/.local/share/go
export XDG_DESKTOP_DIR="/home/shua"
export XDG_DOWNLOAD_DIR="/home/shua/dld"

# UNTARNISHED_PATH=$PATH
# . $HOME/.config/opam/opam-init/init.sh > /dev/null 2> /dev/null || true
# . $HOME/.nix-profile/etc/profile.d/nix.sh || true
# PATH=$UNTARNISHED_PATH
# unset UNTARNISHED_PATH
prepend_path $HOME/.config/opam/*/bin
prepend_path "$HOME/.nix-profile/bin"

rand() {
	n=$1
	v=$(
		(
			echo 'ibase=16; '
			od -x </dev/random |cut -d' ' -f2- |tr 'a-z' 'A-Z' |tr ' ' '\n'
		) \
		| bc \
		| (
			while read v; do
				# keep reading values until we are in a fair range
				if [ $(( v <= (65535 / n * n) )) = 1 ]; then
					echo $((v % n))
				fi
			done
		) \
		| head -n1
	)
	echo $v
}

roll() {
	echo "$*" | grep -q -e '[0-9]*d[0-9]*\(  *[0-9]*d[0-9]*\)*' \
	|| echo "args must be of the form NdM"
	for d in $@; do
		n=$(echo $d | cut -d'd' -f1)
		b=$(echo $d | cut -d'd' -f2)
		printf '%s: ' "$d"
		while [ $n -gt 0 ]; do
			printf '%d ' $(($(rand $b) + 1));
			n=$((n - 1));
		done
		echo
	done
}

# overrides/commands
alias sway="sway -d 2>$HOME/.log/sway"
alias battery='cat /sys/class/power_supply/BAT1/{status,capacity} |paste - - |awk '"'"'{ if ($1 ~ /Charging/) {printf "+" } print $2"%" }'"'"
alias dlesg="dmesg -H"
alias doch='sudo mksh -c "$(fc -ln -1)"'
alias ssh="TERM=xterm-256color ssh"
alias emacs="emacs -nw"
alias printlast='fc -ln -1 | awk '"'"'{sub(/^[ \t]*/, ""); print }'"'"

# shorthands
alias df="df -h"
alias du="du -h"

alias ls="\ls -h --color=auto"
alias l="ls -F"
alias ll="ls -l"
alias la="ls -a"

alias E="$EDITOR"

alias hx=/usr/lib/helix/hx

alias ga="git add"
alias gau="git add -u"
alias gb="git branch"
alias gc="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gdH="git diff HEAD"
alias gg="git grep"
alias gl="git lol"
alias gla="git lola"
alias gp="git pull --rebase"
alias gs="git status"

alias wasabi='aws --endpoint-url https://s3.us-east-2.wasabisys.com --profile wasabi-jdll s3'

# echo sourced profile
# echo PATH is $(echo "$PATH" |tr ':' ' ')

unset -f append_path
unset -f prepend_path
unset -f purge_path

