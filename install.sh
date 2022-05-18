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

if [ -d $DIR/zsh-syntax-highlighting ]; then
	if ! git -C $DIR/zsh-syntax-highlighting pull --stat 2>&1 | grep -q 'Already up to date.'; then
		echo ".zsh-syntax-highlighting updated"
		CHANGED=1
	fi
else
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $DIR/zsh-syntax-highlighting > /dev/null 2>&1 && echo ".zsh-syntax-highlighting cloned" && CHANGED=1
fi

if [ -d $DIR/vim/bundle/Vundle.vim ]; then
	if ! git -C $DIR/vim/bundle/Vundle.vim pull --stat 2>&1 | grep -q 'Already up to date.'; then
		echo "vundle updated"
		CHANGED=1
	fi
else
	git clone https://github.com/VundleVim/Vundle.vim.git $DIR/vim/bundle/Vundle.vim > /dev/null 2>&1 && echo "vundle cloned" && CHANGED=1
fi

vim +PluginInstall +qa > /dev/null 2>&1
vim +PluginUpdate +qa > /dev/null 2>&1
vim +PluginClean! +qa > /dev/null 2>&1

for file in zshrc gitignore vimrc vim pyrc zsh-syntax-highlighting; do
	if [ ! -e $HOME/.${file} ]; then
		ln -sf $DIR/$file $HOME/.$file && echo ".$file installed"
		CHANGED=1
	fi
done

# Espanso
if [ $(uname) == "Darwin" ]; then
	if [ ! -L $HOME/Library/Preferences/espanso/default.yml ]; then
		mkdir -p $HOME/Library/Preferences/espanso
		ln -sf $DIR/espanso.yml $HOME/Library/Preferences/espanso/default.yml && echo ".espanso installed"
	fi
else
	if [ ! -L $HOME/.config/espanso/default.yml ]; then
		mkdir -p $HOME/.config/espanso
		ln -sf $DIR/espanso.yml $HOME/.config/espanso/default.yml && echo ".espanso installed"
	fi
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

# Old stuff to check and clean up
for file in tmux.conf.local tmux.conf xsession xscreensaver conky.d Xresources cwmrc freebsd_wallpaper.sh; do
	if [ -L $HOME/.${file} ]; then
		rm -f $HOME/.$file && echo ".$file removed"
		CHANGED=1
	fi
done


if [ ${CHANGED} -eq 0 ]; then
	echo 'Nothing changed.'
fi
