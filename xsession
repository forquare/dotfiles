#!/bin/sh
#exec /usr/local/bin/startxfce4

setxkbmap gb

xrdb -load .Xresources

if [ -f /usr/local/bin/dbus-update-activation-environment ]; then
	/usr/local/bin/dbus-update-activation-environment --all $DISPLAY &
	/usr/local/bin/dbus-launch --sh-syntax --exit-with-session cwm &
fi

if [ -f /usr/local/bin/gnome-keyring-daemon ]; then
	eval export $(/usr/local/bin/gnome-keyring-daemon --start --components=pkcs11,secrets) &
fi

if [ -f /usr/local/bin/VBoxClient ]; then
	/usr/local/bin/VBoxClient --clipboard &
fi

if [ -f /usr/local/bin/feh ] && [ -d ~/nextcloud/Pictures/freebsd-backgrounds/Finals/ ]; then
	/usr/local/bin/feh -z --bg-fill ~/nextcloud/Pictures/freebsd-backgrounds/Finals/ &
fi

if [ -f /usr/local/bin/xclock ]; then
	/usr/local/bin/xclock -d &
fi

if [ -f /usr/local/bin/conky ] && [ -d ~/.conky.d ]; then
	for E in ~/.conky.d/*; do
		/usr/local/bin/conky -b -c ${E} &
	done
fi

/usr/local/bin/nextcloud &

if ping -c 1 -t 5 bil-desktop; then
	autossh -M 0 -N -L 4242:localhost:4242 bil@bil-desktop &
fi

exec /usr/local/bin/cwm
