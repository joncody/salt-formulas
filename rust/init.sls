{% from "rust/map.jinja" import rust with context %}

include:
  - optsrc

rust_deps:
  pkg.installed:
    - names:
      - build-essential
      - curl
      - gcc
      - libssl-dev
      - pkg-config
    - require:
      - file: optsrc

rust_bootstrap:
  cmd.run:
    - name: |
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
          --no-modify-path \
          --profile default \
          --default-toolchain stable \
          --component clippy,rust-analyzer
    - env:
      - RUSTUP_HOME: {{ rust.prefix }}/rustup
      - CARGO_HOME: {{ rust.prefix }}
    - creates: {{ rust.prefix }}/bin/rustup
    - require:
      - pkg: rust_deps

rust_components:
  cmd.run:
    - name: {{ rust.prefix }}/bin/rustup component add clippy rust-analyzer
    - env:
      - RUSTUP_HOME: {{ rust.prefix }}/rustup
      - CARGO_HOME: {{ rust.prefix }}
    - creates: {{ rust.prefix }}/bin/rust-analyzer
    - require:
      - cmd: rust_bootstrap

rust_perms:
  file.directory:
    - name: {{ rust.prefix }}
    - user: root
    - group: root
    - dir_mode: '0755'
    - file_mode: '0755'
    - recurse:
        - mode
    - require:
      - cmd: rust_components
