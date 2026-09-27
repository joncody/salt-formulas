salt-formulas
=============

[![SaltStack](https://img.shields.io/badge/SaltStack-Formula-57BCAD?style=flat&logo=saltstack&logoColor=white)](https://saltproject.io/)
[![Rust](https://img.shields.io/badge/Updater-Rust-orange?style=flat&logo=rust&logoColor=white)](https://www.rust-lang.org/)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-FCC624?style=flat&logo=linux&logoColor=black)](https://www.kernel.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A high-performance, deterministic SaltStack repository for provisioning workstations and server infrastructure.

### Architecture Highlights
- **Prefix Isolation:** Software installs under dedicated `/opt/<tool>` hierarchies.
- **Dual-Shell Dynamic Environment:** Dynamic path discovery for POSIX shells (`/etc/profile.d/opt_env.sh`) and Nushell (`/etc/nushell/env.nu`).
- **Deterministic & Fast:** Salt formulas pin versions in `map.jinja`. Highstates finish in seconds with zero network probing.
- **Automated GitOps Upgrades:** Bundled with `salt-bump`, an asynchronous Rust CLI that checks upstream APIs and bumps `map.jinja` files in-place.

### Checking for Updates
```bash
# Check upstream releases across all formulas
cargo run --manifest-path updater/Cargo.toml -- check

# Update map.jinja files in-place
cargo run --manifest-path updater/Cargo.toml -- update

# Inspect diff, commit, and apply
git diff
git commit -am "chore: bump formulas"
sudo salt-call --local state.apply
```
