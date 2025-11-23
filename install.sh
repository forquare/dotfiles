#!/bin/sh

CHANGED=0

# Old stuff to check and clean up
for file in tmux.conf.local tmux.conf xsession xscreensaver conky.d Xresources cwmrc freebsd_wallpaper.sh; do
	if [ -L $HOME/.${file} ]; then
		rm -f $HOME/.$file && echo ".$file removed"
		CHANGED=1
	fi
done

if [ -f $HOME/.gitconfig ]; then
	if ! grep -q 'ben@lavery-griffiths.com' $HOME/.gitconfig; then
		read -p "$HOME/.gitconfig contains old details - regenerate? [y/N]: " regen_gitconfig
		if echo "${regen_gitconfig}" | grep -qi '^y'; then
			echo "Moving .gitconfig to $HOME/.gitconfig_moved_$(date '+%Y-%m-%d')"
			mv $HOME/.gitconfig $HOME/.gitconfig_moved_$(date '+%Y-%m-%d')
			CHANGED=1
		fi
	fi
fi

################################################################################
################################################################################

if ! echo $(uname) | grep -i BSD > /dev/null; then
	# If we aren't on a *BSD then we'll use Bash to figure out where we are
	DIR=$(bash -c 'cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd')
	# FROM http://stackoverflow.com/questions/59895/
	#		can-a-bash-script-tell-what-directory-its-stored-in
else
	DIR=$(dirname $(readlink -f "$0"))
fi

if [ -d $DIR/zsh-syntax-highlighting ]; then
	if ! git -C $DIR/zsh-syntax-highlighting pull --stat 2>&1 | grep -qE 'Already up to date.|Already up-to-date.'; then
		echo ".zsh-syntax-highlighting updated"
		CHANGED=1
	fi
else
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $DIR/zsh-syntax-highlighting > /dev/null 2>&1 && echo ".zsh-syntax-highlighting cloned" && CHANGED=1
fi

for file in zshrc gitignore pyrc zsh-syntax-highlighting; do
	if [ ! -e $HOME/.${file} ]; then
		ln -sf $DIR/$file $HOME/.$file && echo ".$file installed"
		CHANGED=1
	fi
done

# Neovim
if command -v nvim > /dev/null; then
	nvim_config_dir="${XDG_CONFIG_HOME:-"$HOME/.config"}/nvim"
	if [ ! -d ${nvim_config_dir} ]; then
		ln -sf "${DIR}/nvim" "${nvim_config_dir}" && echo 'nvim configuration installed'
		CHANGED=1
	fi
	nvim --headless "+Lazy! sync" "+MasonToolsInstall" +qa > /dev/null 2>&1 &
fi

# Vim
if command -v vim > /dev/null; then
	for file in vimrc vim; do
		if [ ! -e $HOME/.${file} ]; then
			ln -sf $DIR/$file $HOME/.$file && echo ".$file installed"
			CHANGED=1
		fi
	done

	if [ -d $DIR/vim/bundle/Vundle.vim ]; then
		if ! git -C $DIR/vim/bundle/Vundle.vim pull --stat 2>&1 | grep -qE 'Already up to date.|Already up-to-date.'; then
			echo "vundle updated"
			CHANGED=1
		fi
	else
		git clone https://github.com/VundleVim/Vundle.vim.git $DIR/vim/bundle/Vundle.vim > /dev/null 2>&1 && echo "vundle cloned" && CHANGED=1
	fi

	{
		vim +PluginInstall +qa > /dev/null 2>&1
		vim +PluginUpdate +qa > /dev/null 2>&1
		vim +PluginClean! +qa > /dev/null 2>&1
	} &
fi

# Atuin
if [ -f ~/.config/atuin/config.toml ]; then
	while read -r LINE; do
		property=$(echo $LINE | awk '{print $1}')
		value=$(echo $LINE | awk '{print $2}')
		if ! grep -q "^$property = $value" ~/.config/atuin/config.toml; then
			sed -i.bak "s|# *$property *=.*|$property = $value|" ~/.config/atuin/config.toml
			CHANGED=1
		fi
	done < $DIR/atuin.conf
	if [ -f ~/.config/atuin/config.toml.bak ]; then
		rm ~/.config/atuin/config.toml.bak
		echo "Atuin configured"
	fi
fi

# Ghostty
if command -v ghostty > /dev/null; then
	ghostty_config_dir="${XDG_CONFIG_HOME:-"$HOME/.config"}/ghostty"
	ghostty_config_file="${ghostty_config_dir}/config"

	if [ ! -d ${ghostty_config_file} ]; then
		mkdir -p ${ghostty_config_dir}
	fi

	if [ ! -L "${ghostty_config_file}" ]; then
		ln -sf "${DIR}/ghostty.config" "${ghostty_config_file}" && echo "${ghostty_config_file} installed"
		CHANGED=1
	fi

	if [ ! -d "${ghostty_config_dir}/themes_cache" ]; then
		mkdir -p "${ghostty_config_dir}/themes_cache"
		if [ ! -d "${ghostty_config_dir}/themes_cache/jb.nvim" ]; then
			git clone https://github.com/nickkadutskyi/jb.nvim "${ghostty_config_dir}/themes_cache/jb.nvim" > /dev/null 2>&1 && echo "ghostty jb.nvim theme cloned"
			CHANGED=1
		else
			if ! git -C "${ghostty_config_dir}/themes_cache/jb.nvim" pull --stat 2>&1 | grep -qE 'Already up to date.|Already up-to-date.'; then
				echo "ghostty jb.nvim theme updated"
				CHANGED=1
			fi
		fi
	fi

	if [ ! -d "${ghostty_config_dir}/themes" ]; then
		mkdir -p "${ghostty_config_dir}/themes"
	fi

	for FILE in "${ghostty_config_dir}/themes_cache/jb.nvim/extras/ghostty"/*; do
		if echo "${FILE}" | grep -q 'README.md'; then
			continue
		fi
		if [ ! -f "{ghostty_config_dir}/themes/$(basename "${FILE}")" ]; then
			ln -sf "${FILE}" "${ghostty_config_dir}/themes/$(basename "${FILE}")" && echo "ghostty theme $(basename "${FILE}") installed"
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
	read -p "Signing Key " key
	read -p "Github username " github

	# escape strings for sed
	name=$(printf "%s\n" "$name" | sed 's/[\&/]/\\&/g')
	email=$(printf "%s\n" "$email" | sed 's/[\&/]/\\&/g')
	key=$(printf "%s\n" "$key" | sed 's/[\&/]/\\&/g')
	github=$(printf "%s\n" "$github" | sed 's/[\&/]/\\&/g')
	home=$(printf "%s\n" "$HOME" | sed 's/[\&/]/\\&/g')

	# replace NAME, EMAIL, GITHUB, HOME
	sed "s/NAME/$name/g" $DIR/gitconfig | sed "s/EMAIL/$email/g" | sed "s/KEY/$key/g" | sed "s/GITHUB/$github/g" | sed "s/HOME/$home/g" > $HOME/.gitconfig
	echo ".gitconfig installed"
	CHANGED=1
fi

################################################################################
################################################################################

wait

if [ ${CHANGED} -eq 0 ]; then
	echo 'Nothing changed.'
fi
