# Environmental customizations
# for myrveln@gmail.com
# 2013-09-05 20:45:32

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:/usr/local/sbin:$PATH";

# Load the extra shell dotfiles
for FILE in ~/.{aliases,functions}; do
	[ -r "${FILE}" ] && [ -f "${FILE}" ] && source "${FILE}";
done;
unset FILE;

# Bash and shell programs
# Skip history spam
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTCONTROL="ignoredups"

# Enable TTY for gpg commit sign
export GPG_TTY=$(tty)

# Skip suffixes in tab completion
export FIGNORE=".o:~"
export HOSTFILE=~/.hosts

# Don't exit on ^D
set -o ignoreeof

# less
# Case insensitive search
export LESS="-i"

# Editor
export EDITOR=emacs
export VISUAL=emacs

# Screen
export SCREENRC=${HOME}/.screenrc

# Terminal colours (after installing GNU coreutils)
NM="\[\033[0;38m\]"	  #means no background and white lines
HI="\[\033[0;37m\]"	  #change this for letter colors
HII="\[\033[0;31m\]"	  #change this for letter colors
SI="\[\033[0;33m\]"	  #this is for the current directory
IN="\[\033[0m\]"

# Prompt
#export PS1="$NM[ $HI\u $HII\\h $SI\w$NM ] $IN" # hostname
export PS1="$NM[ $HI\u$HII myrveln $SI\w$NM ] $IN" # hardcoded

export LC_ALL=en_GB.UTF-8
