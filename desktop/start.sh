#!/bin/bash

export DISPLAY=:1

mkdir -p "$HOME/.vnc"
PASSWD_PATH="$HOME/.vnc/passwd"
echo "$VNC_PW" | vncpasswd -f > $PASSWD_PATH
chmod 600 $PASSWD_PATH

#workaround, lock files are not removed if container is re-run otherwise which makes vncserver unaccessible
rm -rf /tmp/.X1-lock
rm -rf /tmp/.X11-unix/X1

vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION & PID_SUB=$!

top -b