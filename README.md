# nixos-cfg

A minimal, flake-based NixOS configuration for the `nixos` host and the `yanh` user account.

This repository manages both system-level NixOS settings and user-level Home Manager configuration. It is intended as a reproducible personal workstation/server configuration with a practical CLI-focused toolset.

## Overview

This configuration includes:

* Nix flakes and Home Manager integration
* NixOS system configuration for host `nixos`
* User configuration for `yanh`
* Zsh shell setup with useful aliases
* Starship prompt
* Neovim as the default editor
* Git configuration with Delta integration and SSH signing
* Podman with Docker compatibility
* OpenSSH server with password login disabled
* VMware and QEMU guest support
* Weekly Nix garbage collection and store optimisation
* Custom terminfo entries for Kitty and Ghostty terminals
* LLM agent tools via `llm-agents.nix`

## Repository layout

```text
.
├── flake.nix                  # Flake entry point
├── flake.lock                 # Locked flake inputs
├── configuration.nix          # Main NixOS system configuration
├── hardware-configuration.nix # Generated hardware configuration
├── home.nix                   # Home Manager entry point for user yanh
├── shell.nix                  # Zsh, fzf, zoxide, and Starship configuration
├── git.nix                    # Git, global gitignore, Delta, and signing config
├── llm-agents.nix             # LLM agent packages
└── terminfo.nix               # Custom terminal definitions
```

## Main features

### System configuration

The system configuration enables:

* GRUB bootloader
* Latest Linux kernel package set
* NetworkManager
* OpenSSH
* Podman with Docker-compatible commands
* VMware guest support
* QEMU guest agent
* Weekly garbage collection
* Automatic Nix store optimisation
* Unfree packages
* Flakes and `nix-command`

The configured hostname is:

```text
nixos
```

The configured timezone is:

```text
America/Edmonton
```

### User account

The main user account is:

```text
yanh
```

The user is configured with:

* Zsh as the login shell
* Membership in `wheel` and `networkmanager`
* SSH public key authentication
* Home Manager configuration

> Note: The configuration includes an initial password placeholder. Change the user password immediately after the first login.

### Home Manager

Home Manager is used to manage user-level packages and configuration.

User packages include tools such as:

* `home-manager`
* `hydra-check`
* `zip`, `xz`, `unzip`, `p7zip`, `gnutar`
* `ripgrep`, `fd`, `jq`, `yq-go`, `delta`, `lsd`
* `mtr`, `iperf3`, `dnsutils`, `aria2`, `socat`, `nmap`
* `bat`, `fastfetch`, `btop`, `htop`, `iotop`, `iftop`
* `sysstat`, `lm_sensors`, `ethtool`, `pciutils`, `usbutils`
* `mise`, `devenv`, `tree-sitter`, `gcc`, `gnumake`
* `nodejs_24`
* `python314`

### Shell environment

The shell configuration enables:

* Zsh
* Syntax highlighting
* `fzf`
* `zoxide`
* Starship prompt

Useful aliases include:

```sh
ls="lsd"
l="ls -l"
la="ls -la"
..="cd .."
...="cd ../.."
rebuild="sudo nixos-rebuild switch"
rebuild-home="sudo nixos-rebuild switch --flake ~/.nixos-cfg#nixos"
update-system="nix flake update --flake /etc/nixos && sudo nixos-rebuild switch"
dump-garbage="sudo nix-collect-garbage -d && sudo nix-store --optimise && df -h"
```

### Neovim

Neovim is enabled through Home Manager and configured as the default editor.

The configuration uses Neovim from the unstable nixpkgs input.

### Git

Git is configured with:

* User name and email
* SSH commit and tag signing
* Delta as pager and diff viewer
* `main` as the default branch
* Rebase-based pulls
* Autosquash and autostash
* A global gitignore file
* Convenience aliases

## Usage

### Clone the repository

```sh
git clone https://github.com/hongyanca/nixos-cfg.git ~/.nixos-cfg
cd ~/.nixos-cfg
```

### Build and switch

To apply the configuration:

```sh
sudo nixos-rebuild switch --flake ~/.nixos-cfg#nixos
```

### Update flake inputs

To update the locked inputs:

```sh
nix flake update
```

Then rebuild:

```sh
sudo nixos-rebuild switch --flake ~/.nixos-cfg#nixos
```

### Clean old generations and optimise the store

```sh
sudo nix-collect-garbage -d
sudo nix-store --optimise
```

The configuration also enables automatic weekly garbage collection.

## Important notes

This repository is tailored to a specific machine and user. Before using it on another system, review and adjust:

* `networking.hostName`
* `users.users.yanh`
* SSH public keys
* `boot.loader.grub.device`
* `hardware-configuration.nix`
* Filesystem UUIDs
* `system.stateVersion`
* `home.stateVersion`
* Firewall settings
* Sudo settings
* Git user identity and signing key

The current configuration disables the firewall and enables passwordless sudo for the `wheel` group. Review these settings carefully before using this configuration on a networked or production system.

## Applying to a fresh NixOS install

A typical flow for adapting this repository to a new machine is:

```sh
sudo nixos-generate-config
```

Then copy or merge the generated `hardware-configuration.nix` into this repository.

After reviewing machine-specific settings, run:

```sh
sudo nixos-rebuild switch --flake .#nixos
```

## License

MIT
