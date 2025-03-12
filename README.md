# Dotfiles

Welcome to my dotfiles repository! This repository contains configuration files for various tools and applications that I use, allowing for easy setup and synchronization across multiple systems.

## Installation

To set up these dotfiles on your system, follow these steps:

### Clone the Repository
```bash
git clone https://github.com/myrveln/dotfiles.git ~/dotfiles
```

### Run Bootstrap Script
The `bootstrap.sh` script will install all the dotfiles in your home directory automatically. Run the following command:
```bash
cd ~/dotfiles
./bootstrap.sh
```

## Additional Setup Scripts

### `brew.sh`
This script installs essential packages and applications using Homebrew. To run it:
```bash
./brew.sh
```
This will install packages defined in the script, ensuring your system has all necessary dependencies.

### `macos.sh`
This script applies macOS system settings for an optimized workflow. Run it with:
```bash
./macos.sh
```
It will adjust various macOS preferences, such as UI/UX enhancements, Dock settings, and Finder behavior.

## License
This repository is open-source. Feel free to use and modify it as needed.

## Contributions
If you have suggestions or improvements, feel free to submit a pull request!
