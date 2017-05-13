#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# machine specific stuff
[ -f "$HOME/conf/local/xinitrc" ] && . "$HOME/conf/local/xinitrc"
[ -z "$DWMCLOCK_FMT" ] && DWMCLOCK_FMT="date"

xrdb -merge ~/.Xresources

#start-pulseaudio-x11 &
$HOME/conf/bin/dwmclock.sh "$DWMCLOCK_FMT" &
(which compton >/dev/null) && exec compton -fGC -i 0.9 --sw-opti &
$HOME/conf/bin/wp &
exec dwm 2> ~/.log/dwm.log
#exec /home/shua/bin/dwm 2> ~/dwm.log
#exec st -g 205x64
