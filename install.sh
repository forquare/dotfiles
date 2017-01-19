#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # FROM http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in

for file in bashrc zshrc gitignore vimrc vim tmux.conf pyrc; do
	if [ -e $HOME/.${file} ]; then
		echo ".$file found, doing nothing"
	else
		ln -sf $DIR/$file $HOME/.$file && echo ".$file installed"
	fi

	#On OS X we need to source .bashrc from .profile
	if [[ "$file" == "bashrc" ]] && [[ `uname` == "Darwin" ]]; then
		grep "source ~/.bashrc" ~/.profile > /dev/null
		if [[ $? != 0 ]]; then
			echo "    Sourcing .bashrc in .profile"
			echo "source ~/.bashrc" >> ~/.profile
		else
			echo "    .bashrc already sourced in .profile"
		fi
	fi
			
done

#for directory in bash-completions; do
#	if [ -d $HOME/.${directory} ]; then
#		echo ".$directory found, doing nothing"
#	else
#		ln -sf $DIR/$directory $HOME/.$directory && echo ".$directory installed"
#	fi
#done


if [[ `uname` == "FreeBSD" ]]; then
	if [ -e $HOME/.xsession ]; then
		echo ".xsession found, doing nothing"
	else
		ln -sf $DIR/xsession $HOME/.xsession && echo ".xsession installed"
	fi
fi

# gitconfig
if [ -e $HOME/.gitconfig ]; then
	echo ".gitconfig found, doing nothing"
else 
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
fi
