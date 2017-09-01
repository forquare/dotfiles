#Ben's bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#######################
#     Shell Prefs     #
#######################
export EDITOR='vim'
export PAGER='less'
export HISTCONTROL=ignoredups:ignoreboth
export HISTTIMEFORMAT='[%d/%m %H:%M] '
export HISTSIZE=2000
export HISTFILESIZE=10000
shopt -s histappend
export PROMPT_COMMAND="history -a"
bind 'set completion-ignore-case on'
bind 'set mark-symlinked-directories on'
set -o vi
export PS1="\[\e[00;36m\]\u@\h:\W \$>\[\e[0m\]"

umask 0022

if [ $(id -u) -eq 0 ]; then
	export PS1="\[\e[00;31m\]\u@\h:\W \$>\[\e[0m\]"
fi

#######################
#       Aliases       #
#######################
alias update_history='history -n'
alias more='less'
alias vi='vim'
alias mkdir='mkdir -p'
alias ls='ls -hF'

#######################
#    Path settings    #
#######################
if [ `uname` == "Darwin" ]; then
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

#######################
#         SSH         #
#######################
if [ -n "$SSH_CLIENT" ]; then
	export PS1="\[\e[00;36m\]\u@\[\e[0;37m\]\h\[\e[00;36m\]:\W \$>\[\e[0m\]"
fi

######################
#     COMPLETIONS    #
######################
#if [ -d ~/.bash-completions ]; then
#	source ~/.bash-completions/*.bash
#fi

#######################
#       History       #
#######################

#Last edited 03/04/16
# - Removed completions, no longer default shell

#Last edited 05/04/15
# - Added git autocompletion
# - Removed tmux on SSH login

#Last edited: 18/12/14
# - Split PATH stuff up with tests
# - Removed lesspipe

#Last edited: 20/08/
# - Removed Admiral Acbar Crtl-C trap - it was annoying

#Last edited: 20/05/14
# - Added Admiral Acbar Crtl-C trap
# - Added "tmux on start" if using SSH

#Last edited: 26/10/2013
# - Added check for Darwin (Cygwin doesn't like OS X paths)

#Last edited: 24/10/2013
# - Moved .bashrc to Dropbox/bashrc, hard linked to ~/.bashrc

#Last edited: 24/10/2013
# - export PS1 variable ("\e[0;36m\u@\h:\w \$>\e[m ")

#Last edited: 06/12/2011
#Changes not recorded
