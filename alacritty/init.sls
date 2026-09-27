{% from "alacritty/map.jinja" import alacritty with context %}

include:
  - rust
  - optsrc
  - .conf

alacritty_deps:
  pkg.installed:
    - names:
      - cmake
      - pkg-config
      - libfreetype-dev
      - libfontconfig1-dev
      - libxcb-xfixes0-dev
      - libxkbcommon-dev
      - python3
    - require:
      - file: optsrc

alacritty_git:
  git.latest:
    - name: {{ alacritty.repo }}
    - rev: v{{ alacritty.version }}
    - target: /opt/src/alacritty
    - require:
      - pkg: alacritty_deps
      - cmd: rust_bootstrap

alacritty_build:
  cmd.run:
    - cwd: /opt/src/alacritty
    - name: |
        RUSTFLAGS="-C target-cpu=native" /opt/rust/bin/cargo build --release --locked
        mkdir -p {{ alacritty.prefix }}/bin
        cp target/release/alacritty {{ alacritty.prefix }}/bin/alacritty
        cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg 2>/dev/null || true
        desktop-file-install extra/linux/Alacritty.desktop 2>/dev/null || true
        /opt/rust/bin/cargo clean
    - onchanges:
      - git: alacritty_git
