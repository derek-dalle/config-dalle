
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
    PATH="$HOME/bin:$HOME/usr/bin:$HOME/usr/local/bin"
else
    PATH="$HOME/bin:$HOME/usr/bin:$HOME/usr/local/bin/:$PATH"
fi

# Module path
if [[ "$MODULEPATH" == "" ]]; then
    # Source the environment module thing to tell it what shell is being used.
    . $MODULESHOME/init/bash
fi
# Now add the useful part of the path.
MODULEPATH="$HOME/Modules:$MODULEPATH"

# Python path
if [[ "$PYTHONPATH" == "" ]]; then
    # Create a new Python path.
    export PYTHONPATH="$HOME/Documents/Python"
else
    # Append to the Python path.
    export PYTHONPATH="$PYTHONPATH:$HOME/Documents/Python"
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
PS1="\[\e]0;\h:\w\a\]\h:\W$ "

# MATLAB-like searching with up arrow
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Login to my server.
alias ssh-pegasus='ssh -X dalle@aero-pegasus.engin.umich.edu'

# NAS secure server
alias ssh-sfe='ssh -Y ddalle@sfe1.nas.nasa.gov'

# University of Michigan server (generic)
alias ssh-itcs='ssh -X dalle@login.itcs.umich.edu'
# University of Michigan with MATLAB
alias ssh-umich='ssh -X dalle@scs.itd.umich.edu'


# University of Michigan computers
if [[ "$HOSTNAME" == *".engin.umich.edu" ]]; then
    # Clusters
    alias ssh-flux='ssh flux-login.engin.umich.edu'
    alias ssh-nyx='ssh nyx-login.engin.umich.edu'
    # CAEN login machines
    alias ssh-login='ssh -Y login.engin.umich.edu'
fi

# Server-specific commands
if [[ "$HOSTNAME" == "aero-pegasus" ]]; then
    # Commands to launch MATLAB by version
    alias matlab-2012a='/usr/local/MATLAB/R2012a/bin/matlab'
    alias matlab-2011a='/usr/local/MATLAB/R2011a/bin/matlab'
fi

# NASA NAS workstations
if [[ "$HOSTNAME" == *".nas.nasa.gov" ]]; then
    # Starts a socket to secure computing.
    alias sfe-master='ssh -fN sfe-master'
    # Relatively obvious aliases just in case I forget them
    alias ssh-pfe='ssh pfe'
    alias ssh-bridge='ssh bridge3'
    alias ssh-lfe='ssh lfe'
    # Increase the stack size (for Cart3D, at the very least)
    ulimit -s 4194304
fi

# Pleiades nodes
if [[ "$HOSTNAME" == "pfe"*  || "$HOSTNAME" == "bridge"* ]]; then
    # Add additional modulefiles
    module use -a $HOME/share/modulefiles
    # Prevent CSH from choking on colors.
    alias csh='LS_COLORS="" csh'
    # Increase the stack size (for Cart3D, at the very least)
    ulimit -s 4194304
fi

# LOU storage node
if [[ "$HOSTNAME" == "lfe"* ]]; then
    # Get rid of colors completely (appears not to really matter).
    export LS_COLORS=""
    # I want git for this.
    module load git
fi
