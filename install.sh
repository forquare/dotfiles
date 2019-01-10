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

if [ -d $DIR/oh-my-tmux ]; then
	git -C $DIR/oh-my-tmux pull --stat | grep -q 'Already up to date.' || echo ".tmux updated" && CHANGED=1
else
	git clone https://github.com/gpakosz/.tmux.git $DIR/oh-my-tmux > /dev/null 2>&1 && echo ".tmux cloned" && CHANGED=1
fi

for file in zshrc gitignore vimrc vim tmux.conf.local pyrc ; do
	if [ ! -e $HOME/.${file} ]; then
		ln -sf $DIR/$file $HOME/.$file && echo ".$file installed"
		CHANGED=1
	fi
done

# This is for files inside directories
for file in oh-my-tmux/.tmux.conf ; do
	_file=$(basename $file)
	_dir=$(dirname $file)
	
	if echo ${_file} | grep '^\.' > /dev/null; then
		PREFIX=''
	else
		PREFIX='.'
	fi
	
	if [ ! -e $HOME/${PREFIX}${_file} ]; then
		ln -sf $DIR/$_dir/$_file $HOME/${PREFIX}$_file && echo "${PREFIX}$_file installed"
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
