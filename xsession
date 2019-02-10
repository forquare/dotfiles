#!/bin/sh
#exec /usr/local/bin/startxfce4

set -x
setxkbmap gb

xrdb -load .Xresources

/usr/local/libexec/at-spi-bus-launcher &
/usr/local/libexec/at-spi2-registryd --use-gnome-session &
/usr/local/bin/dbus-update-activation-environment --all &
echo ${DBUS_SESSION_BUS_ADDRESS}
eval $(/usr/local/bin/gnome-keyring-daemon --start --components=pkcs11,secrets)
export GNOME_KEYRING_CONTROL
echo ${GNOME_KEYRING_CONTROL}

if [ -f /usr/local/bin/VBoxClient ]; then
	/usr/local/bin/VBoxClient --clipboard &
	/usr/local/bin/VBoxClient --display &
	/usr/local/bin/VBoxClient --seamless &
	/usr/local/bin/VBoxClient --draganddrop &
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

(sleep 10 && /usr/local/bin/nextcloud &)

#if ping -c 1 -t 5 bil-desktop; then
#	autossh -M 0 -N -L 4242:localhost:4242 bil@bil-desktop &
#fi

/usr/local/bin/dbus-launch --sh-syntax --exit-with-session cwm
