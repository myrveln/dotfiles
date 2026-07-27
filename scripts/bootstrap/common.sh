#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "${SCRIPT_DIR}/../.." && pwd)}"

log_info() {
    echo "[bootstrap] $*"
}

log_warn() {
    echo "[bootstrap] WARNING: $*"
}

log_skip() {
    echo "[bootstrap] SKIP: $*"
}
