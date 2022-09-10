#!/bin/bash

set -e
set -u

yum install -y tigervnc-server \
	nano \
	net-tools \
    nmap \
    octave \
	sudo \
	tcllib \
	vim \
	wget \
	xorg-x11-server-Xvfb \
	xterm \
	passwd

echo "Install Xfce4 UI components and disable xfce-polkit" 
yum --enablerepo=epel -y -x gnome-keyring --skip-broken groupinstall "Xfce"
yum -y groups install "Fonts"
yum erase -y *power*
rm /etc/xdg/autostart/xfce-polkit*
/bin/dbus-uuidgen > /etc/machine-id

echo "Cleaning yum cache"
yum clean all