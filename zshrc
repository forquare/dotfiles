# Ben's ZSHrc

#####################
#    Shell Prefs    #
#####################
# Set edditing and viewing preferences
export EDITOR='vim'
export PAGER='less'

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

#####################
#   History Prefs   #
#####################
export HISTFILE=~/.zsh_history  # Save history here
export HISTSIZE=1000            # Internal size
export SAVEHIST=10000           # File size
setopt HIST_IGNORE_DUPS         # No duplicate entries
setopt HIST_SAVE_NO_DUPS        # No duplicate entries
setopt INC_APPEND_HISTORY_TIME  # Add history to file on execution
setopt HIST_REDUCE_BLANKS       # Don't save blank lines
setopt EXTENDED_HISTORY         # Add timestamps to history
setopt SHARE_HISTORY            # Share history between active shells
setopt HIST_BEEP                # Beep if we go beyond top/bottom of history

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
        if [ -d /usr/local/clamXav/bin ]; then
                export PATH="$PATH:/usr/local/clamXav/bin"
        fi

	# Apple Developer Tools
        if [ -d /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin ]; then
                export PATH="$PATH:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin"
        fi

	# Mono tools, mainly for CKAN (KSP)
        if [ -d /Library/Frameworks/Mono.framework/Versions/Current/bin ]; then
                export PATH="$PATH:/Library/Frameworks/Mono.framework/Versions/Current/bin"
        fi

	# I keep homebrew in /opt
        if [ -d /opt/homebrew/sbin ]; then
                export PATH="/opt/homebrew/sbin:$PATH"
        fi

	# I've taken to using pkgsrc instead
	if [ -d /opt/pkg/bin ]; then
		export PATH="/opt/pkg/bin:$PATH"
	fi

	# I keep homebrew in /opt
        if [ -d /opt/homebrew/bin ]; then
                export PATH="/opt/homebrew/bin:$PATH"
        fi
fi

# Minecraft scripts
if [ -d /home/manaha-minecrafter/opt/bin ]; then
        export PATH="$PATH:/home/manaha-minecrafter/opt/bin"
fi

# Awesome Perlbrew
if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
        source ~/perl5/perlbrew/etc/bashrc
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

#####################
#        SSH       #
#####################
# If we are coming in via SSH, turn the PS1 yellow
if [ -n "$SSH_CLIENT" ]; then
	export PROMPT="%F{yello}%n@%m:%c %#>%f"
fi

#####################
#      History      #
#####################

# Created: 02/04/2016
# Cloned much from bashrc
