#!/bin/sh
#exec /usr/local/bin/startxfce4

setxkbmap gb

xrdb -load .Xresources

if [ -f /usr/local/bin/dbus-update-activation-environment ]; then
  /usr/local/bin/dbus-update-activation-environment --all &
  /usr/local/bin/dbus-launch --sh-syntax --exit-with-session cwm &
fi

if [ -f /usr/local/bin/gnome-keyring-daemon ]; then
  /usr/local/bin/gnome-keyring-daemon --start --components=pkcs11 &
fi

if [ -f /usr/local/libexec/at-spi2-registryd ]; then
  /usr/local/libexec/at-spi2-registryd --use-gnome-session &
fi

if [ -f /usr/local/bin/VBoxClient ]; then
  /usr/local/bin/VBoxClient --clipboard &
fi

if [ -f /usr/local/bin/xclock ]; then
  /usr/local/bin/xclock -d &
fi

#/usr/local/bin/nextcloud &

exec /usr/local/bin/cwm
