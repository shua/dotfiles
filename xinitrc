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

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

# bummer, touchscreen is going
xinput disable 9
#xinput float 9
xrdb -merge ~/.Xresources

#touchegg &
#start-pulseaudio-x11 &
dwmclock.sh &
compton -fGC -i 0.9 --sw-opti &
wp &
exec /usr/bin/dwm 2> ~/dwm.log
#exec /home/shua/bin/dwm 2> ~/dwm.log
#exec /home/shua/bin/loopdwm
#exec st -g 205x64
