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

# Function to install package from tap.
function BrewInstallTap() {
    for item in "${@}"; do
	local param=(${item//=/ })
	if ! [[ $(brew tap | grep "${param[0]}") ]]; then
	    brew tap "${param[0]}"
	    BrewInstall "${param[1]}"
	else
	    BrewInstall "${param[1]}"
	fi
    done
}

# Make sure we’re using the latest Homebrew.
brew update

# Display any warnings from `brew doctor`
brew doctor

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
BrewInstall coreutils

# Install latest Bash.
BrewInstall bash bash-completion@2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
    echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
    chsh -s "${BREW_PREFIX}/bin/bash"
fi

# Install GnuPG to enable PGP-signing commits.
BrewInstall gnupg pinentry-mac
if [[ -f "${HOME}/.gnupg/gpg-agent.conf" ]]; then
    if [[ ! $(grep "pinentry-program /opt/homebrew/bin/pinentry-mac" "${HOME}/.gnupg/gpg-agent.conf") ]]; then
        echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> "${HOME}/.gnupg/gpg-agent.conf"
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
            lzop \
            jq \
            nmap \
            wget \
            siege \
            awscli \
            ansible \
            git \
            node \
            cfn-lint \

# Install packages that requires tap.
BrewInstallTap "aws/tap=aws-sam-cli" \
               "hashicorp/tap=hashicorp/tap/terraform" \
               "terraform-docs/tap=terraform-docs" \

# Remove outdated versions from the cellar.
brew cleanup
