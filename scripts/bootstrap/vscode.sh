#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/common.sh"

vscode_source_dir="${DOTFILES_DIR}/.config/vscode/User"
vscode_user_dir="${HOME}/Library/Application Support/Code/User"

if [[ ! -d "${vscode_source_dir}" ]]; then
    log_skip "VS Code source directory not found; skipping settings symlink setup."
    exit 0
fi

if [[ ! -d "/Applications/Visual Studio Code.app" && ! -d "${vscode_user_dir}" ]]; then
    log_skip "VS Code not detected; skipping settings symlink setup."
    exit 0
fi

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
