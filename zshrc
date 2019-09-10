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

# 755 for directories, 644 for files
umask 0022

# Set PS1 to user@host:$PWD %>
export PROMPT="%F{cyan}%n@%m:%c %#>%f"

# If we are root, change the PS1 to red
if [ $(id -u) -eq 0 ]; then
	# Only happens if `sudo zsh`
	export PROMPT="%F{red}%n@%m:%c %#>%f"
fi

# Set the Terminal title if using xterm
case $TERM in
	(*xterm*)

	# Write some info to terminal title.
	# This is seen when the shell prompts for input.
	function precmd {
	print -Pn "\e]0;%n@%m: %~\a"
	}
	# Write command and args to terminal title.
	# This is seen while the shell waits for a command to complete.
	function preexec {
	printf "\033]0;%s\a" "$1"
	}

	;;
esac

# Correct spelling
setopt CORRECT

# Err...?  Document soon please :D
autoload -Uz compinit
compinit

# Do not remove trailing slashes from directories OR symlinks to directories
setopt no_auto_remove_slash

# Enable full screen command editing using 'v' in command mode
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line

#####################
#     LOCAL.RC      #
#####################
if [ -f "$HOME/.zshrclocal" ]; then
	source "$HOME/.zshrclocal"
fi

#####################
#   History Prefs   #
#####################
export HISTFILE=~/.zsh_history  # Save history here
export HISTSIZE=1000            # Internal size
export SAVEHIST=10000           # File size
setopt HIST_IGNORE_DUPS         # No duplicate entries
setopt HIST_SAVE_NO_DUPS        # No duplicate entries
setopt HIST_REDUCE_BLANKS       # Do not save blank lines
setopt EXTENDED_HISTORY         # Add timestamps to history
setopt HIST_IGNORE_SPACE        # Do not save lines preceeded with a space
###setopt SHARE_HISTORY         # Share history between active shells
setopt HIST_BEEP                # Beep if we go beyond top/bottom of history
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
alias ncurl='curl -v -o /dev/null'
alias mkdir='mkdir -p'
alias ls='ls -hF'
alias setgopath='export GOPATH=$(pwd)'
alias clsb="printf '\033\143'" # Clear scrollback
alias jsonformat="python -m json.tool"

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

#####################
#        SSH       #
#####################
# If we are coming in via SSH, turn the PS1 yellow
if [ -n "$SSH_CLIENT" ]; then
	export PROMPT="%F{yello}%n@%m:%c %#>%f"
fi

#####################
#   Python Prefs    #
#####################
# Specify python rc file, to enable vi style editing and persistent history
export PYTHONSTARTUP=~/.pyrc

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

# 19/12/2018
# Added LSCOLORS

# 28/05/2017
# Removed some PATH settings, and moved some others to zshrclocal

# Created: 02/04/2016
# Cloned much from bashrc
