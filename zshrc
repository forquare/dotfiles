# Ben's ZSHrc 
#####################
#    Shell Prefs    #
#####################
# Set edditing and viewing preferences
export EDITOR='vim'
export PAGER='less'
export VISUAL='vim'

export LESS='-X' # Don't send termcap initialization and deinitialization strings to the terminal

# Vi keys, what else?
bindkey -v

# Start a reverse search using ctrl+r
bindkey '^R' history-incremental-search-backward

# Make sure that the delete key actually deletes
bindkey '\e[3~' delete-char

# Using what is already on the current line, reverse search with up/down
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
if [ $(uname) = "Linux" ]; then
	bindkey "^[OA" history-beginning-search-backward-end
	bindkey "^[OB" history-beginning-search-forward-end
fi

# 755 for directories, 644 for files
umask 0022

# Set PS1 to $PWD %>
export PS1='%F{cyan}%c %#>%f'

# Set right PS1 to VCS info
export RPS1='%F{cyan}${vcs_info_msg_0_}%f'

# Correct spelling
setopt CORRECT

# Load autocompletion
autoload -Uz compinit
compinit

# Do not remove trailing slashes from directories OR symlinks to directories
setopt no_auto_remove_slash

# Enable full screen command editing using 'v' in command mode
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Enable vcs_info
autoload -Uz vcs_info
setopt prompt_subst

# Configure vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

precmd(){
	# Load vcs_info
	vcs_info
	
	# Write some info to terminal title.
	# This is seen when the shell prompts for input.
	case $TERM in
		(*xterm*)
		print -Pn "\e]0;%n@%m: %~\a"
		;;
	esac
}

preexec(){
	# Write command and args to terminal title.
	# This is seen while the shell waits for a command to complete.
	case $TERM in
		(*xterm*)
		printf "\033]0;%s\a" "$1"
		;;
	esac
}

#####################
#     LOCAL.RC      #
#####################
if [ -f "$HOME/.zshrclocal" ]; then
	source "$HOME/.zshrclocal"
fi

#####################
#   History Prefs   #
#####################
export HISTFILE=~/.zsh_history   # Save history here
export HISTSIZE=100000           # Maximum number of  events  stored  in  the  internal  history  list.
export SAVEHIST=10000000         # Maximum number of history events to save in the history file.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_REDUCE_BLANKS        # Do not save blank lines
setopt HIST_IGNORE_SPACE         # Do not save lines preceeded with a space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_NO_STORE             # Remove  the  history (fc -l) command from the history list when invoked.
[ $(uname) != "Linux" ] && setopt INC_APPEND_HISTORY_TIME  # Add history to file on execution (Linux doesn't like this)
alias history='fc -lni 0 -1'

#####################
#      Aliases      #
#####################
if command -v less > /dev/null; then
	alias more='less'
fi
if command -v vim > /dev/null; then
	alias vi='vim'
	alias view='vim -R'
fi
if command -v git > /dev/null; then
	alias git='git --no-pager'
fi
if command -v kubectl > /dev/null; then
	alias k='kubectl'
fi

alias mkdir='mkdir -p'
[ $(uname) = "Linux" ] && alias ls='ls -hF --color' || alias ls='ls -hF'
alias jsonformat="python -m json.tool"
alias _clear='clear'
alias clear='_clear && printf "\033[3J"'

#####################
#   PATH Settings   #
#####################
# If I'm on a Mac check this stuff out, if not then don't even bother
if [[ $(uname) == "Darwin" ]]; then
	# Apple Developer Tools
        if [ -d /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin ]; then
                export PATH="$PATH:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin"
        fi

	#macOS seems to put useful things like ping and chown under /sbin or /usr/sbin...
	export PATH="$PATH:/sbin:/usr/sbin"
fi

if [ -d $HOME/.cargo/bin ]; then
	export PATH="$PATH:$HOME/.cargo/bin"
fi

# Mostly I have scripts from nextcloud
if [ -d $HOME/nextcloud/scripts ]; then
        export PATH="$HOME/nextcloud/scripts:$PATH"
elif [ -d $HOME/scripts ]; then
	# Sometimes I have scripts in my home dir
        export PATH="$HOME/scripts:$PATH"
fi

# Sometimes I have binaries in my home dir
if [ -d $HOME/bin ]; then
        export PATH="$HOME/bin:$PATH"
fi

# Make sure /usr/local/bin is at the forefront of PATH
if [ -d /usr/local/bin ]; then
	export PATH="/usr/local/bin:$PATH"
fi

# Actually Perlbrew needs to be  first
if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
	source ~/perl5/perlbrew/etc/bashrc
fi

#####################
#        SSH       #
#####################
# If we are coming in via SSH, turn the PS1 yellow
if [ -n "$SSH_CLIENT" ]; then
	export PS1="%F{yello}%n@%m:%c %#>%f"
	export RPS1='%F{yello}${vcs_info_msg_0_}%f'
fi

#####################
#   Python Prefs    #
#####################
# Specify python rc file, to enable vi style editing and persistent history
export PYTHONSTARTUP=~/.pyrc

#####################
#   Docker help     #
#####################
if command -v docker > /dev/null; then
	dockerstop(){
		docker stop $(docker ps -a -q)
	}
	dockerrm(){
		docker rm -f $(docker ps -a -q)
	}
	dockerrmi(){
		docker rmi -f $(docker images -q)
	}
	killdocker(){
		dockerstop
		dockerrm
		dockerrmi
	}
fi

#####################
#   rmssh           #
#####################
rmssh(){
	for EACH in $@; do
		cat ~/.ssh/known_hosts | grep -v $EACH > ~/.ssh/temp_known_hosts
		mv ~/.ssh/temp_known_hosts ~/.ssh/known_hosts
	done
}

#####################
#   dirhash         #
#####################
dirhash(){                 
	if [ $# -gt 1 ]; then
		for E in $*; do
		dirhash ${E}
	done
	return 0
	fi
	if [ ! -d $1 ]; then
		return 1
	fi
	cd $1
	hash=$(find . -type f -exec sha256sum {} + | awk '{print $2, "\t", $1}' | sort | sha256sum | awk '{print $1}')
	printf "%s\t%s\n" $1 $hash
	cd - > /dev/null
}

#####################
#   TILIX           #
#####################
if [ -f /etc/profile.d/vte.sh ]; then
	if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
		source /etc/profile.d/vte.sh
	fi
fi


#####################
#   iTerm2          #
#####################
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#####################
#   Command Prefs   #
#####################
# ls colours for BSD ls
# 'fb' f=foreground, b=background
ls_dir='hx' #...........................light-grey default
ls_sym='fx' #...........................magenta    default
ls_sock='cx' #..........................green      default
ls_pipe='dx' #..........................brown      default
ls_exe='bx' #...........................red        default
ls_blk='eg' #...........................blue       cyan
ls_char='ed' #..........................blue       brown
ls_setuid='ab' #........................black      red
ls_setgid='ag' #........................black      cyan
ls_dir_write_others_sticky='ac' #.......black      green
ls_dir_write_others_no_sticky='ad' #....black      brown
export LSCOLORS="${ls_dir}${ls_sym}${ls_sock}${ls_pipe}${ls_exe}${ls_blk}${ls_char}${ls_setuid}${ls_setgid}${ls_dir_write_others_sticky}${ls_dir_write_others_no_sticky}"
export CLICOLOR=yes

# ls colours for GNU
export LS_COLORS='di=37:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

###########################
# zsh-syntax-highlighting #
###########################
# This must be last:
if [ -f $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then 
	source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

#####################
#      History      #
#####################

# 2020-09-14
# See git logs

