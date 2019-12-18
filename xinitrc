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

# sound?
#start-pulseaudio-x11 &

# graphics
[ -f "$HOME/conf/local/Xresources" ] && xrdb -merge $HOME/conf/local/Xresources
(which compton >/dev/null) && exec compton -fGC -i 0.9 --sw-opti &
$HOME/conf/bin/wp.sh &
#export GDK_SCALE=2
export GDK_DPI_SCALE=2

# input
libinput-gestures -c $HOME/conf/libinput-gestures-trackpad.conf &

# desktop
plumber
setxkbmap dvorak
$HOME/conf/bin/dwmclock.sh "$DWMCLOCK_FMT" &
exec dwm 2> ~/.log/dwm.log
#exec /home/shua/bin/dwm 2> ~/dwm.log
#exec st -g 205x64
