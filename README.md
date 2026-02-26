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

This repo includes a `cl` helper (installed as `~/bin/cl` from this repo's `bin/cl`) for logging into EKS (`eks-<env>`) and OpenShift (`ocp-<env>`).

Options:

- `-n/--namespace <ns>`: sets the kube context default namespace (defaults to `default`)
- `--k9s`: starts `k9s` after login/switch (uses `-n <ns>` only if you explicitly provided `-n`)

If installed, `kubectx`/`kubens` are used for switching context/namespace; otherwise `kubectl config ...` is used.

For OpenShift, API endpoints are intentionally **not** hardcoded. Configure them in a private, git-ignored file:

- Copy `.config/clusters.local.example` to `~/.config/clusters.local`
- Set per-environment variables like:
	- `export CL_OCP_SERVER_TEST="https://api.<your-private-domain>:6443"`

For EKS, AWS profile naming and cluster naming are also intentionally **not** hardcoded. Configure these in `~/.config/clusters.local`:

- `CL_AWS_PROFILE_PREFIX`
- `CL_AWS_PROFILE_SEPARATOR` (defaults to `-`; used as `${CL_AWS_PROFILE_PREFIX}${CL_AWS_PROFILE_SEPARATOR}${env}`)
- `CL_EKS_CLUSTER_NAME_TEMPLATE` (must contain `{env}`)

Then use:

```bash
cl eks-test
cl eks-test -n my-namespace
cl eks-test --k9s
cl eks-test -n my-namespace --k9s

cl ocp-test
cl ocp-test -n my-namespace
cl ocp-test --k9s
cl ocp-test -n my-namespace --k9s
```

## Private local config

This repository is public, so personal/work-specific settings should live in local, untracked files.

- Git identity + optional GPG setup: copy `.config/gitconfig.local.example` to `~/.config/gitconfig.local`
- OpenShift endpoints: copy `.config/clusters.local.example` to `~/.config/clusters.local`

## License
This repository is open-source. Feel free to use and modify it as needed.

## Contributions
If you have suggestions or improvements, feel free to submit a pull request!
