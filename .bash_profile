# Add macOS specific paths to PATH variable when homebrew folder exists
if [[ -d "/opt/homebrew" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/opt/homebrew/sbin:$PATH"
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
fi

# Add Rancher Desktop binary to PATH
if [[ -d "${HOME}/.rd/bin" ]]; then
    export PATH="${HOME}/.rd/bin:$PATH"
fi

# Export generic paths to the PATH variable
export PATH="$HOME/bin:$PATH"

# Load the extra shell dotfiles
for FILE in ~/.{aliases,functions}; do
    [[ -r "${FILE}" ]] && [[ -f "${FILE}" ]] && source "${FILE}"
done
unset FILE

# Bash completion on macOS
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

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

# Silence default shell in macOS
export BASH_SILENCE_DEPRECATION_WARNING=1

# Disable SAM CLI telemetry collection
export SAM_CLI_TELEMETRY=0

# Terminal colours (after installing GNU coreutils)
NM="\[\033[0;38m\]"      #means no background and white lines
HI="\[\033[0;37m\]"      #change this for letter colors
HII="\[\033[0;31m\]"      #change this for letter colors
SI="\[\033[0;33m\]"      #this is for the current directory
IN="\[\033[0m\]"

# Prompt
export PS1="$NM[ $HI\u $HII\\h $SI\w$NM ] $IN" # hostname
#export PS1="$NM[ $HI\u$HII myrveln $SI\w$NM ] $IN" # hardcoded

export LC_ALL=en_GB.UTF-8
