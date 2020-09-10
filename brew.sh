#!/usr/bin/env bash

# Function to install Brew packages when not already installed.
function BrewInstall() {
	for package in "${@}"; do
		brew list ${package} > /dev/null
		if [[ $? -ne 0 ]]; then
			brew install "${package}"
		fi
	done
}

# Make sure we’re using the latest Homebrew.
brew update

# Make sure that brew doctor doesn't show any warnings
BREW_DOCTOR="$(brew doctor)"
if [[ "$?" -gt 0 ]]; then
    echo "Check output from `brew doctor`:"
    echo "${BREW_DOCTOR}"
    exit 1
fi

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
BrewInstall coreutils

# Install latest Bash.
BrewInstall bash bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
  chsh -s "${BREW_PREFIX}/bin/bash"
fi

# Install GnuPG to enable PGP-signing commits.
BrewInstall gnupg pinentry-mac
if [[ -f "${HOME}/.gnupg/gpg-agent.conf" ]]; then
    if [[ ! $(grep "pinentry-program /usr/local/bin/pinentry-mac" "${HOME}/.gnupg/gpg-agent.conf") ]]; then
        echo "pinentry-program /usr/local/bin/pinentry-mac" >> "${HOME}/.gnupg/gpg-agent.conf"
        killall gpg-agent
    fi
else
    echo "Could not find gpg-agent.conf."
    exit 1
fi

# Install more recent versions of some macOS tools.
BrewInstall grep openssh screen

# Install other tools.
BrewInstall emacs \
            jq \
            nmap \
            wget \
            siege \
            awscli \
            ansible \
            git \
            node \

# Install aws-sam-cli, and enable tap aws/tap
if ! [[ $(brew tap | grep "aws/tap") ]]; then
    brew tap aws/tap
    BrewInstall "aws-sam-cli"
else
    BrewInstall "aws-sam-cli"
fi

# Remove outdated versions from the cellar.
brew cleanup
