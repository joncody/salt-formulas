salt-formulas
=============

A collection of high-performance Salt formulas for building tools and services from source.

### Architecture Highlights
- Builds source trees in `/opt/src/<tool>` and installs binaries to `/opt/<tool>`.
- Uses `map.jinja` to support version pinning and pillar overrides.
- Idempotent execution using `creates:` and `onchanges:` guards.
- Automatic CPU core detection (`make -j{{ grains['num_cpus'] }}`) for speed.
- Configures global binary and library paths via `bashrc`.
