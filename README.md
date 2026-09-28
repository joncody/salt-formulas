# salt-formulas

A deterministic, modular Infrastructure-as-Code repository for provisioning modern Linux developer workstations and server environments.

[![SaltStack](https://img.shields.io/badge/SaltStack-Formula-57BCAD?style=flat&logo=saltstack&logoColor=white)](https://saltproject.io/)
[![Platform: Linux](https://img.shields.io/badge/Platform-Ubuntu%20%7C%20Debian-FCC624?style=flat&logo=linux&logoColor=black)](https://www.kernel.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Architecture

- **Prefix Isolation:** All software compiles or extracts into dedicated `/opt/<tool>` hierarchies.
- **Dynamic Dual Shell:** Global PATH and tool discovery for POSIX shells (`/etc/profile.d/opt_env.sh`) and Nushell (`/etc/nushell/env.nu`).
- **Zero-Dotfile Customization:** Workstation tools are configured at the system level via `<app>/conf.sls` with Gruvbox Light defaults.
- **Self-Updating GitOps:** Pinned versions in `map.jinja` are checked and bumped via the bundled `updater/` CLI tool.

---

## Software Inventory

| Category | Tools | Method |
| :--- | :--- | :--- |
| **Terminal & Shell** | Alacritty, Nushell, Zellij | Cargo Build & Pre-compiled Binaries |
| **Editor & Files** | Helix, Yazi | Pre-compiled Tarballs + System Config |
| **Fonts** | Hack Nerd Font | GitHub Release Archive (`fc-cache`) |
| **Language Toolchains**| Rust (`rustup`), Go, Node.js | Official Toolchains & Runtimes |
| **Server Daemons** | Nginx (`+njs`), PostgreSQL, Dovecot, OpenSMTPD, Pure-FTPd | Source (`./configure && make`) |
| **Media & Messaging** | FFmpeg, Libsodium, ZeroMQ Stack (`zmq`, `czmq`, `zyre`, `filemq`) | Source (`make`) |
| **Containers & Net** | Docker CE, Host Firewall (`nftables`) | Official APT Repo & Syntax-Checked Rules |

---

## Quickstart (Fresh Machine / VM)

```bash
# 1. Clone repository to Salt root
sudo git clone https://github.com/joncody/salt-formulas.git /srv/salt
cd /srv/salt

# 2. Bootstrap SaltStack (installs masterless salt-minion)
make bootstrap

# 3. Dry-run test
make dry-run

# 4. Provision the entire workstation
make apply
```

### Granular Targeting

```bash
# Apply a single formula (installs tool + config)
sudo salt-call --local state.apply helix

# Apply only configuration changes (skips builds/installs)
sudo salt-call --local state.apply helix.conf
sudo salt-call --local state.apply nftables.conf
sudo salt-call --local state.apply nginx.conf
```
