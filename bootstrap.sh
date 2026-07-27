#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1;

DOTFILES_DIR="$(pwd)"
git pull origin master --quiet

function Execute() {
    rsync --exclude ".git/" \
	  --exclude ".gitignore" \
      --exclude ".github/" \
	  --exclude ".DS_Store" \
	  --exclude "Brewfile" \
	  --exclude "README.md" \
	  --exclude "bootstrap.sh" \
	  --exclude "brew.sh" \
	  --exclude "macos.sh" \
      --exclude "scripts/" \
      --exclude ".config/vscode/" \
      -avh . ~

    shopt -s nullglob
    for bootstrap_hook in "${DOTFILES_DIR}/scripts/bootstrap"/*.sh; do
        if [[ "$(basename "${bootstrap_hook}")" == "common.sh" ]]; then
            continue
        fi
        DOTFILES_DIR="${DOTFILES_DIR}" bash "${bootstrap_hook}"
    done
    shopt -u nullglob

    # shellcheck source=/dev/null
    source ~/.bash_profile
}

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
    Execute
else
    read -p "This will overwrite all dotfiles in your home directory ($(echo ${HOME})). Are you sure? (y/n) " -n 1
    echo ""
    if [[ ${REPLY} =~ ^[Yy]$ ]]; then
	    Execute
    fi
fi
unset Execute
unset DOTFILES_DIR
