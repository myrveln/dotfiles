#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN_LOCK_DIR="${TMPDIR:-/tmp}/brew-sh.lock"

# Prevent concurrent runs, which can collide on Homebrew lock files.
if ! mkdir "${RUN_LOCK_DIR}" 2>/dev/null; then
    echo "Another brew.sh run is already in progress. Wait for it to finish and try again." >&2
    exit 1
fi

trap 'rmdir "${RUN_LOCK_DIR}" >/dev/null 2>&1 || true' EXIT

ensure_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        return 0
    fi

    echo "Homebrew not found. Installing..."

    if ! command -v curl >/dev/null 2>&1; then
        echo "Error: curl is required to install Homebrew." >&2
        return 1
    fi

    # Official installer (interactive as needed).
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Make `brew` available in the current shell.
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    command -v brew >/dev/null 2>&1
}

ensure_homebrew

# Make sure we’re using the latest Homebrew.
brew update

# Display any warnings from `brew doctor` (skip non-prefixed coreutils check)
doctor_checks=()
while IFS= read -r check; do
    [[ "${check}" == "check_for_non_prefixed_coreutils" ]] && continue
    doctor_checks+=("${check}")
done < <(brew doctor --list-checks)
brew doctor "${doctor_checks[@]}"

# Upgrade any already-installed formulae.
brew upgrade --yes

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Trust the taps we need (this must be done before bundle)
export HOMEBREW_NO_REQUIRE_TAP_TRUST="1"

# Install packages/casks/taps from Brewfile.
brew bundle --file "${SCRIPT_DIR}/Brewfile"

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
    echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
    chsh -s "${BREW_PREFIX}/bin/bash"
fi

# Configure GnuPG pinentry (Brewfile installs gnupg + pinentry-mac).
GPG_DIR="${HOME}/.gnupg"
GPG_AGENT_CONF="${GPG_DIR}/gpg-agent.conf"
PINENTRY_LINE="pinentry-program ${BREW_PREFIX}/bin/pinentry-mac"

# Only initialize if directory doesn't exist or config is incomplete
if [[ ! -d "${GPG_DIR}" ]] || [[ ! -f "${GPG_AGENT_CONF}" ]] || ! grep -q "^${PINENTRY_LINE}$" "${GPG_AGENT_CONF}"; then
    mkdir -p "${GPG_DIR}"
    chmod 700 "${GPG_DIR}"
    touch "${GPG_AGENT_CONF}"

    if ! grep -q "^${PINENTRY_LINE}$" "${GPG_AGENT_CONF}"; then
        echo "${PINENTRY_LINE}" >> "${GPG_AGENT_CONF}"
        killall gpg-agent 2>/dev/null || true
    fi
fi

# Remove outdated versions from the cellar.
brew cleanup
