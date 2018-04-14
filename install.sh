#!/bin/sh

if [ $0 != "./install.sh" ]; then
	echo "please cd into top level of the dotfiles directory, and rerun"
	exit 1
fi

CONF_DIR=$(basename $(pwd))
DOT_CONF="compton gitconfig xinitrc"
SHELL_CONF=$(cd shell; ls)
XDG_CONF="user-dirs.dirs vis"
BIN=$(cd bin; ls)

if [ "$1" = "-l" ]; then
	echo CONF_DIR $CONF_DIR
	echo DOT_CONF $DOT_CONF
	echo SHELL_CONF $SHELL_CONF
	echo XDG_CONF $XDG_CONF
	echo BIN $BIN
	exit 0
fi

echo dot config
cd ~
for c in $DOT_CONF; do
	test -e .$c || ln -s $CONF_DIR/$c .$c
done

echo shell config
for c in $SHELL_CONF; do
	test -e .$c || ln -s $CONF_DIR/shell/$c .${c}
done

echo xdg config
[ -d ~/.config ] || mkdir ~/.config
cd ~/.config
for c in $XDG_CONF; do
	test -e $c || ln -s ../$CONF_DIR/$c
done

echo bin
[ -d ~/bin ] || mkdir ~/bin
cd ~/bin
for b in $BIN; do
	if [ -x ../$CONF_DIR/bin/$b ]; then
		name=$(echo $b |sed 's/\.sh//g')
		test -e $name || ln -s ../$CONF_DIR/bin/$b $name
	fi
done

echo log dir
[ -d ~/.log ] || mkdir ~/.log

