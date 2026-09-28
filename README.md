# salt-formulas

A deterministic, modular Infrastructure-as-Code repository for provisioning modern Linux developer workstations and server environments.

[![SaltStack](https://img.shields.io/badge/SaltStack-Formula-57BCAD?style=flat&logo=saltstack&logoColor=white)](https://saltproject.io/)
[![Platform: Linux](https://img.shields.io/badge/Platform-Ubuntu%20%7C%20Debian-FCC624?style=flat&logo=linux&logoColor=black)](https://www.kernel.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Architecture

- **Prefix Isolation:** All software compiles or extracts into dedicated `/opt/<tool>` hierarchies.
- **Dynamic Dual Shell:** Global PATH and tool discovery for POSIX shells (`/etc/profile.d/opt_env.sh`, `/etc/bash.bashrc`) and Nushell (`/etc/nushell/env.nu`).
- **Zero-Dotfile Customization:** Workstation tools are configured at the system level via `<app>/conf.sls` with Gruvbox Light defaults.
- **Self-Updating GitOps:** Pinned versions in `map.jinja` are checked and bumped via the bundled `updater/` CLI tool (`salt-bump`).

---

## Software Inventory

| Category | Tools | Method |
| :--- | :--- | :--- |
| **Terminal & Shell** | Alacritty, Nushell, Zellij | Cargo Build & Pre-compiled Binaries |
| **Editor & Files** | Helix, Yazi | Pre-compiled Tarballs + System Config |
| **Fonts** | Hack Nerd Font | GitHub Release Archive (`fc-cache`) |
| **Language Toolchains**| Rust (`rustup`), Go, Node.js, TLA+ | Official Toolchains & Runtimes (`/opt/tla`) |
| **Server Daemons** | Nginx (`+njs`), PostgreSQL, Dovecot, OpenSMTPD, Pure-FTPd | Source (`./configure && make`) |
| **Media & Messaging** | FFmpeg, Libsodium, yt-dlp, ZeroMQ Stack (`zmq`, `czmq`, `zyre`, `filemq`) | Source & Standalone Binaries |
| **Containers & Net** | Docker CE, Host Firewall (`nftables`) | Official APT Repo & Syntax-Checked Rules |

---

## Quickstart (Fresh Machine / VM)

```bash
# 1. Clone repository to Salt root
sudo git clone https://github.com/joncody/salt-formulas.git /srv/salt
cd /srv/salt

# 2. Bootstrap SaltStack (installs masterless salt-minion)
make bootstrap

# 3. Optional: Provision Rust toolchain early
#    Required if you want to run 'make check' or 'make update' before provisioning the whole system:
sudo salt-call --local state.apply rust
#    Or use the Makefile shortcut:
make rust

# 4. Run a dry-run test
make dry-run

# 5. Provision the entire machine
make apply

# 6. Initialize current user workspace (safely copies Helix & Nushell templates)
make init-user
```

### Granular Targeting

```bash
# Apply a single formula (installs tool + config)
sudo salt-call --local state.apply rust
sudo salt-call --local state.apply helix
sudo salt-call --local state.apply tla

# Apply only configuration changes (skips builds/installs)
sudo salt-call --local state.apply helix.conf
sudo salt-call --local state.apply nftables.conf
sudo salt-call --local state.apply nginx.conf
sudo salt-call --local state.apply shell_env
```

---

## Upstream Version Management (`salt-bump`)

This repository includes a standalone GitOps updater tool written in Rust (`updater/`):

- `make check`: Scans GitHub tags, release redirects, and upstream APIs in parallel with zero API rate limits to check for newer versions across all packages.
- `make update`: Updates all `map.jinja` files in-place with latest versions and reconciles any version drift.

> **Prerequisite:** The updater tool requires **Cargo and Rust**.
>
> On a brand-new machine, `make check` and `make update` will fail until the Rust toolchain is compiled/installed. Provision the system Rust toolchain first:
>
> ```bash
> sudo salt-call --local state.apply rust
> # or:
> make rust
> ```

### Workflows

#### 1. Local Machine Upgrades (No Commit Access Required)
If you clone or fork this repository for personal workstation or server provisioning, you do not need write access to upstream. You can fetch and compile the newest upstream releases on your local machine at any time:

```bash
# 1. Check for newer software versions
make check

# 2. Update local map.jinja files to latest upstream releases
make update

# 3. Apply state changes to build and deploy the new versions
make apply
```

#### 2. Contributing Version Bumps
If you would like to submit updated formulas back upstream:

```bash
# 1. Update map.jinja definitions
make update

# 2. Review version diffs
git diff

# 3. Commit to your fork and submit a Pull Request
git checkout -b chore/bump-upstream-versions
git commit -am "chore: bump upstream formula versions"
git push origin chore/bump-upstream-versions
```
