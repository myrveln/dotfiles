# Dotfiles

Welcome to my dotfiles repository! This repository contains configuration files for various tools and applications that I use, allowing for easy setup and synchronization across multiple systems.

## Installation

To set up these dotfiles on your system, follow these steps:

### Clone the Repository
```bash
git clone https://github.com/myrveln/dotfiles.git ~/dotfiles
```

### Run Bootstrap Script
The `bootstrap.sh` script syncs tracked dotfiles to your home directory and runs bootstrap hooks from `scripts/bootstrap/` (for example, VS Code setup and AWS helper checks). Run the following command:
```bash
./bootstrap.sh
```

## Additional Setup Scripts

### Homebrew (`Brewfile` / `brew.sh`)
Packages are tracked in `Brewfile` and installed via `brew bundle`.

To install everything:
```bash
brew bundle --file Brewfile
```

Or run the helper script (does `brew update/doctor/upgrade`, runs `brew bundle`, and applies a couple of extra tweaks like setting the default shell + GPG pinentry):
```bash
./brew.sh
```

If Homebrew isn't installed yet, `brew.sh` will install it first.

### `macos.sh`
This script applies macOS system settings for an optimized workflow. Run it with:
```bash
./macos.sh
```
It will adjust various macOS preferences, such as UI/UX enhancements, Dock settings, and Finder behavior.

## Cluster login helper (`cl`)

This repo includes a `cl` helper (installed as `~/bin/cl` from this repo's `bin/cl`) for logging into EKS and OpenShift.

Main commands:

- `cl login eks <env> [account-type-token] [-n <namespace>] [--k9s]`
- `cl login ocp <env> [-n <namespace>] [--k9s]`
- `cl config show <env> [account-type-token]`
- `cl doctor`

If installed, `kubectx`/`kubens` are used for switching context/namespace; otherwise `kubectl config ...` is used.

For OpenShift, API endpoints are intentionally **not** hardcoded. Configure them in a private, git-ignored file:

- Copy `.config/clusters.local.example` to `~/.config/clusters.local`
- Set per-environment variables like:
	- `export CL_OCP_SERVER_TEST="https://api.<your-private-domain>:6443"`

For EKS, account types, profile naming, and cluster naming are intentionally **not** hardcoded. Configure these in `~/.config/clusters.local`:

- `CL_AWS_ACCOUNT_TYPES` (for example `typea typeb`)
- `CL_AWS_ACCOUNT_TYPE_DEFAULT` (for example `typea`)
- `CL_AWS_ACCOUNT_TYPE_ALIASES` (for example `typea:ta typeb:tb`)
- `CL_AWS_PROFILE_PREFIX`
- `CL_AWS_PROFILE_SEPARATOR` (optional, default `-`)
- Profile name is derived as `${CL_AWS_PROFILE_PREFIX}${CL_AWS_PROFILE_SEPARATOR}${env}${CL_AWS_PROFILE_SEPARATOR}${account_type}`
- `CL_EKS_CLUSTER_NAME_TEMPLATE` (must contain `{env}` and `{type}`)
- `CL_EKS_REGION` (optional, default `eu-north-1`)
- `CL_ASSUME_REQUIRED` (optional, default `1`; set to `0` to allow login flow without `assume`)
- EKS kube context alias is `eks-<env>-<account-type>` (for example `eks-qa-typea`)

Then use:

```bash
cl login eks qa
cl login eks qa ta
cl login eks devtest typeb
cl login eks qa ta -n my-namespace --k9s

cl login ocp test
cl login ocp test -n my-namespace
cl login ocp test --k9s

cl config show qa
cl config show qa tb
cl doctor
```

## Private local config

This repository is public, so personal/work-specific settings should live in local, untracked files.

- Git identity + optional GPG setup: copy `.config/gitconfig.local.example` to `~/.config/gitconfig.local`
- OpenShift endpoints: copy `.config/clusters.local.example` to `~/.config/clusters.local`
- Generic local settings (including a stable prompt hostname): copy `.config/generic.local.example` to `~/.config/generic.local`
- Personal SSH hosts: copy `.config/ssh.local.example` to `~/.config/ssh.local`
- AWS Session Manager SSH helper ([qoomon/aws-ssm-ssh-proxy-command](https://github.com/qoomon/aws-ssm-ssh-proxy-command)): `./bootstrap.sh` will prompt on first install and will keep the helper up to date on later runs if it already exists

## License
This repository is open-source. Feel free to use and modify it as needed.

## Contributions
If you have suggestions or improvements, feel free to submit a pull request!
