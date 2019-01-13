#!/bin/sh
#exec /usr/local/bin/startxfce4

setxkbmap gb

xrdb -load .Xresources

dbus-update-activation-environment --all
/usr/local/bin/dbus-launch --sh-syntax --exit-with-session cwm
/usr/local/bin/gnome-keyring-daemon --start --components=pkcs11
/usr/local/libexec/at-spi2-registryd --use-gnome-session

#/usr/local/bin/nextcloud &

exec /usr/local/bin/cwm
