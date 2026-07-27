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
      --exclude ".config/vscode/" \
      -avh . ~

    local vscode_source_dir="${DOTFILES_DIR}/.config/vscode/User"
    local vscode_user_dir="${HOME}/Library/Application Support/Code/User"

    if [[ -d "${vscode_source_dir}" ]]; then
        if [[ -d "/Applications/Visual Studio Code.app" || -d "${vscode_user_dir}" ]]; then
            mkdir -p "${vscode_user_dir}"
            if [[ -f "${vscode_source_dir}/settings.json" ]]; then
                ln -sfn "${vscode_source_dir}/settings.json" "${vscode_user_dir}/settings.json"
            fi
            if [[ -f "${vscode_source_dir}/keybindings.json" ]]; then
                ln -sfn "${vscode_source_dir}/keybindings.json" "${vscode_user_dir}/keybindings.json"
            fi
            if [[ -d "${vscode_source_dir}/snippets" ]]; then
                mkdir -p "${vscode_user_dir}/snippets"
                for snippet in "${vscode_source_dir}/snippets"/* "${vscode_source_dir}/snippets"/.[!.]* "${vscode_source_dir}/snippets"/..?*; do
                    [[ -e "${snippet}" ]] || continue
                    cp -R "${snippet}" "${vscode_user_dir}/snippets/"
                done
            fi
        else
            echo "VS Code not detected; skipping settings symlink setup."
        fi
    else
        echo "VS Code source directory not found; skipping VS Code settings symlink setup."
    fi

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
