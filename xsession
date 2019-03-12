#!/bin/sh
#exec /usr/local/bin/startxfce4

set -x
setxkbmap gb

start_sleep=0

xrdb -load .Xresources

if which cwm >/dev/null 2>&1 ; then
	SESSION=${1:-cwm}
else
	SESSION=${1:-startfluxbox}
fi

if which gnome-keyring-daemon >/dev/null 2>&1 ; then
	eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
	export SSH_AUTH_SOCK
	export GPG_AGENT_INFO
fi

if [ -f /usr/local/bin/VBoxClient ]; then
	/usr/local/bin/VBoxClient --clipboard &
	/usr/local/bin/VBoxClient --display &
	/usr/local/bin/VBoxClient --seamless &
	/usr/local/bin/VBoxClient --draganddrop &
	start_sleep=5
fi

if [ -f /usr/local/bin/feh ] && [ -d ~/nextcloud/Pictures/freebsd-backgrounds/Finals/ ]; then
	(sleep ${start_sleep} && /usr/local/bin/feh -z --bg-fill ~/nextcloud/Pictures/freebsd-backgrounds/Finals/ &)
fi

if [ -f /usr/local/bin/xclock ]; then
	(sleep ${start_sleep} && /usr/local/bin/xclock -d &)
fi

if [ -f /usr/local/bin/conky ] && [ -d ~/.conky.d ]; then
	for E in ~/.conky.d/*; do
		(sleep ${start_sleep} && /usr/local/bin/conky -b -c ${E} &)
	done
fi

#(sleep 10 && /usr/local/bin/nextcloud &)

#if ping -c 1 -t 5 bil-desktop; then
#	autossh -M 0 -N -L 4242:localhost:4242 bil@bil-desktop &
#fi

echo "`date`:  $SESSION" >>~/sessions
if which ck-launch-session >/dev/null 2>&1 ; then
	exec ck-launch-session dbus-launch --sh-syntax --exit-with-session "$SESSION"
else
	exec "$SESSION"
fi
