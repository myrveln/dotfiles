#!/usr/bin/env bash

# Function to install Brew packages when not already installed.
function BrewInstall() {
	for package in ${@}; do
		local check=$(brew list ${1})
		if [[ $? -ne 0 ]]; then
			brew install ${package}
		fi
	done
}

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
BrewInstall coreutils
if [[ ! -f "${BREW_PREFIX}/bin/sha256sum" ]] && [[ ! -L "${BREW_PREFIX}/bin/sha256sum" ]]; then
	echo inside
	ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"
fi

# Install latest Bash.
BrewInstall bash bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
  chsh -s "${BREW_PREFIX}/bin/bash"
fi

# Install GnuPG to enable PGP-signing commits.
BrewInstall gnupg

# Install more recent versions of some macOS tools.
BrewInstall grep openssh screen

# Install other tools.
BrewInstall emacs \
            jq \
            nmap \
            wget \
            siege \
            awscli \
            git \
            googler \

# Remove outdated versions from the cellar.
brew cleanup
