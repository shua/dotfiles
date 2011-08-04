#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
# exec /usr/bin/xset m 1/4 1 &
#exec /usr/bin/ssh-agent ck-launch-session awesome

DEFAULT_SESSION=awesome
EXEC_C=exec ck-launch-session dbus-launch
case $1 in
  awesome|xfce4|openbox) $EXEC_C $1 ;;
  *) $EXEC_C $DEFAULT_SESSION ;;
esac
