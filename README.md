salt-formulas
=============

[![SaltStack](https://img.shields.io/badge/SaltStack-Formula-57BCAD?style=flat&logo=saltstack&logoColor=white)](https://saltproject.io/)
[![Jinja2](https://img.shields.io/badge/Templates-Jinja2-B41717?style=flat&logo=jinja&logoColor=white)](https://jinja.palletsprojects.com/)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-FCC624?style=flat&logo=linux&logoColor=black)](https://www.kernel.org/)
[![Type: IaC](https://img.shields.io/badge/Type-Infrastructure%20as%20Code-blue?style=flat)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A collection of high-performance Salt formulas for building tools and services from source.

### Architecture Highlights
- Builds source trees in `/opt/src/<tool>` and installs binaries to `/opt/<tool>`.
- Uses `map.jinja` to support version pinning and pillar overrides.
- Idempotent execution using `creates:` and `onchanges:` guards.
- Automatic CPU core detection (`make -j{{ grains['num_cpus'] }}`) for speed.
- Configures global binary and library paths via `bashrc`.
