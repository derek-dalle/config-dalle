
# ~/.bashrc: executed by bash(1) for non-login shells.
#
# See /usr/share/doc/bash/examples/startup-files (in the package
# bash-doc) for examples.
#

# This is placed here automatically by environment-modules.
case "$0" in
          -sh|sh|*/sh)	modules_shell=sh ;;
       -ksh|ksh|*/ksh)	modules_shell=ksh ;;
       -zsh|zsh|*/zsh)	modules_shell=zsh ;;
    -bash|bash|*/bash)	modules_shell=bash ;;
esac
# Make a process to run modulecmd
module() { eval `/usr/bin/modulecmd $modules_shell $*`; }

# Prepend local folders to relevant paths.
# General path
if [ -z $PATH ]; then
	PATH="$HOME/usr/bin:$HOME/usr/local/bin"
else
	PATH="$HOME/usr/bin:$HOME/usr/local/bin/:$PATH"
fi

# Module path
if [ -z $MODULEPATH ]; then
	MODULEPATH="$HOME/Modules"
else
	MODULEPATH="$HOME/Modules:$MODULEPATH"
fi

# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# Don't put duplicate lines in the history.
# Don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# Check the window size after each command and, if necessary,
# Update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color support of ls and also add handy aliases.
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Enable programmable completion features.
# (Probably already applied by /etc/bash.bashrc or similar)
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Set a convenient prompt that also updates the window title.
PS1="\[\e]0;\h:\w\a\]\u@\h$ "

# Convenient login commands
alias ssh-pegasus='ssh -X dalle@aero-pegasus.engin.umich.edu'
alias ssh-flux='ssh flux-login.engin.umich.edu'

# Commands to launch MATLAB by version
alias matlab-2012a='/usr/local/MATLAB/R2012a/bin/matlab'
alias matlab-2011a='/usr/local/MATLAB/R2011a/bin/matlab'

# MATLAB-like searching with up arrow
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
