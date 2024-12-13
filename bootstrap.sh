#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master --quiet

function Execute() {
    rsync --exclude ".git/" \
	  --exclude ".gitignore" \
	  --exclude ".DS_Store" \
	  --exclude "bootstrap.sh" \
	  --exclude "brew.sh" \
	  --exclude "macos.sh" \
	  -avh --no-perms . ~
    source ~/.bash_profile
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    Execute
else
    read -p "This will overwrite all dotfiles in your home directory ($(echo ${HOME})). Are you sure? (y/n) " -n 1
    echo ""
    if [[ ${REPLY} =~ ^[Yy]$ ]]; then
	    Execute
    fi
fi
unset Execute
