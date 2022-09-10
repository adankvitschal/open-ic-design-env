#!/bin/bash

export DISPLAY=:1

mkdir -p "$HOME/.vnc"
PASSWD_PATH="$HOME/.vnc/passwd"
echo "$VNC_PW" | vncpasswd -f > $PASSWD_PATH
chmod 600 $PASSWD_PATH

vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION