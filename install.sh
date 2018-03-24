#!/bin/sh

CHANGED=0

if ! echo $(uname) | grep -i BSD > /dev/null; then
	# If we aren't on a *BSD then we'll use Bash to figure out where we are
	DIR=$( bash -c 'cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd' ) 
	# FROM http://stackoverflow.com/questions/59895/
	#		can-a-bash-script-tell-what-directory-its-stored-in
else
	DIR=$(dirname $(readlink -f "$0"))
fi

for file in zshrc gitignore vimrc vim tmux.conf pyrc; do
	if [ ! -e $HOME/.${file} ]; then
		ln -sf $DIR/$file $HOME/.$file && echo ".$file installed"
		CHANGED=1
	fi
done

if [ $(uname) == "FreeBSD" ]; then
	for file in xsession xscreensaver conkyrc; do
		if [ ! -e $HOME/.${file} ]; then
			ln -sf $DIR/$file $HOME/.$file && echo ".$file installed"
			CHANGED=1
		fi
	done
fi

# gitconfig
if [ ! -e $HOME/.gitconfig ]; then
	echo "Git Details"
	echo "-----------"
	read -p "Name " name
	read -p "Email " email
	read -p "Github username " github

	# escape strings for sed
	name=$(printf "%s\n" "$name" | sed 's/[\&/]/\\&/g')
	email=$(printf "%s\n" "$email" | sed 's/[\&/]/\\&/g')
	github=$(printf "%s\n" "$github" | sed 's/[\&/]/\\&/g')
	home=$(printf "%s\n" "$HOME" | sed 's/[\&/]/\\&/g')

	# replace NAME, EMAIL, GITHUB, HOME
	sed "s/NAME/$name/g" $DIR/gitconfig | sed "s/EMAIL/$email/g" | sed "s/GITHUB/$github/g" | sed "s/HOME/$home/g" > $HOME/.gitconfig
	echo ".gitconfig installed"
	CHANGED=1
fi

if [ ${CHANGED} -eq 0 ]; then
	echo 'Nothing changed.'
fi
