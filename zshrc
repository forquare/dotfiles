# Ben's ZSHrc

#####################
#    Shell Prefs    #
#####################
export EDITOR='vim'
export PAGER='less'

bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward 

umask 0022

export PROMPT="%F{cyan}%n@%m:%c %#>%f"

if [ $(id -u) -eq 0 ]; then
	# Only happens if `sudo zsh`
	export PROMPT="%F{red}%n@%m:%c %#>%f"
fi

setopt CORRECT
autoload -Uz compinit
compinit

zstyle ':completion:*' completer _expand _complete _correct _approximate


#####################
#   History Prefs   #
#####################
export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY_TIME
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_BEEP

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
if [[ $(uname) == "Darwin" ]]; then
        if [ -d /usr/local/clamXav/bin ]; then
                export PATH="$PATH:/usr/local/clamXav/bin"
        fi

        if [ -d /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin ]; then
                export PATH="$PATH:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin"
        fi

        if [ -d /Library/Frameworks/Mono.framework/Versions/Current/bin ]; then
                export PATH="$PATH:/Library/Frameworks/Mono.framework/Versions/Current/bin"
        fi

        if [ -d /opt/homebrew/sbin ]; then
                export PATH="/opt/homebrew/sbin:$PATH"
        fi

        if [ -d /opt/homebrew/bin ]; then
                export PATH="/opt/homebrew/bin:$PATH"
        fi
fi

if [ -d /home/manaha-minecrafter/opt/bin ]; then
        export PATH="$PATH:/home/manaha-minecrafter/opt/bin"
fi

if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
        source ~/perl5/perlbrew/etc/bashrc
fi

if [ -d ~/scripts ]; then
        export PATH="~/scripts:$PATH"
fi

if [ -d ~/bin ]; then
        export PATH="~/bin:$PATH"
fi

#####################
#        SSH       #
#####################
if [ -n "$SSH_CLIENT" ]; then
	export PROMPT="%F{orange}%n@%m:%c %#>%f"
fi

#####################
#      History      #
#####################

# Created: 02/04/2016
# Cloned much from bashrc
