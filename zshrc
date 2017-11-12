# Ben's ZSHrc 
#####################
#    Shell Prefs    #
#####################
# Set edditing and viewing preferences
export EDITOR='vim'
export PAGER='less'
export VISUAL='vim'

# Vi keys, what else?
bindkey -v

# Start a reverse search using ctrl+r
bindkey '^R' history-incremental-search-backward

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

# If we are root, chance the PS1 to red
if [ $(id -u) -eq 0 ]; then
	# Only happens if `sudo zsh`
	export PROMPT="%F{red}%n@%m:%c %#>%f"
fi

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

# Specify python rc file, to enable vi style editing and persistent history
export PYTHONSTARTUP=~/.pyrc

#####################
#   History Prefs   #
#####################
export HISTFILE=~/.zsh_history  # Save history here
export HISTSIZE=1000            # Internal size
export SAVEHIST=10000           # File size
setopt HIST_IGNORE_DUPS         # No duplicate entries
setopt HIST_SAVE_NO_DUPS        # No duplicate entries
setopt HIST_REDUCE_BLANKS       # Don't save blank lines
setopt EXTENDED_HISTORY         # Add timestamps to history
###setopt SHARE_HISTORY         # Share history between active shells
setopt HIST_BEEP                # Beep if we go beyond top/bottom of history
[ $(uname) != "Linux" ] && setopt INC_APPEND_HISTORY_TIME  # Add history to file on execution (Linux doesn't like this)

#####################
#      Aliases      #
#####################
alias more='less'
alias vi='vim'
alias mkdir='mkdir -p'
alias ls='ls -hF'

#####################
#   PATH Settings   #
#####################
# If I'm on a Mac check this stuff out, if not then don't even bother
if [[ $(uname) == "Darwin" ]]; then
	# Apple Developer Tools
        if [ -d /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin ]; then
                export PATH="$PATH:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin"
        fi

	# Mono tools, mainly for CKAN (KSP)
        if [ -d /Library/Frameworks/Mono.framework/Versions/Current/bin ]; then
                export PATH="$PATH:/Library/Frameworks/Mono.framework/Versions/Current/bin"
        fi

	#macOS seems to put useful things like ping and chown under /sbin or /usr/sbin...
	export PATH="$PATH:/sbin:/usr/sbin"
fi

# Awesome Perlbrew
if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
        source ~/perl5/perlbrew/etc/bashrc
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
#     LOCAL.RC      #
#####################
if [ -f "$HOME/.zshrclocal" ]; then
	source "$HOME/.zshrclocal"
fi

#####################
#      History      #
#####################

# 28/05/2017
# Removed some PATH settings, and moved some others to zshrclocal

# Created: 02/04/2016
# Cloned much from bashrc
