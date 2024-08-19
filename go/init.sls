{% from "go/map.jinja" import go with context %}

include:
  - optsrc

go_bootstrap:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - autotools-dev
      - build-essential
      - cmake
      - git
      - libevent-dev
      - libssl-dev
      - libtool
      - openssl
      - pkg-config
      - valgrind
    - require:
      - file: optsrc
  file.managed:
    - name: /opt/src/go1.4-bootstrap-20171003.tar.gz
    - source: https://dl.google.com/go/go1.4-bootstrap-20171003.tar.gz
    - source_hash: sha256=f4ff5b5eb3a3cae1c993723f3eab519c5bae18866b5e5f96fe1102f0cb5c3e52
    - require:
      - pkg: go_bootstrap
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf go1.4-bootstrap-20171003.tar.gz
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - file: go_bootstrap

go_bootstrap-build:
  cmd.run:
    - cwd: /opt/src/go/src
    - name: ./make.bash
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: go_bootstrap

go_bootstrap-move:
  cmd.run:
    - cwd: /opt/src
    - name: mv go go_bootstrap
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: go_bootstrap-build

go_1.17:
  file.managed:
    - name: /opt/src/go1.17.13.src.tar.gz
    - source: https://go.dev/dl/go1.17.13.src.tar.gz
    - source_hash: sha256=a1a48b23afb206f95e7bbaa9b898d965f90826f6f1d1fc0c1d784ada0cd300fd
    - require:
      - cmd: go_bootstrap-move
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf go1.17.13.src.tar.gz
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - file: go_1.17

go_1.17-build:
  cmd.run:
    - cwd: /opt/src/go/src
    - name: GOROOT_BOOTSTRAP=/opt/src/go_bootstrap ./make.bash
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: go_1.17

go_1.17-move:
  cmd.run:
    - cwd: /opt/src
    - name: mv go go1.17
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: go_1.17-build

go_1.20:
  file.managed:
    - name: /opt/src/go1.20.14.src.tar.gz
    - source: https://go.dev/dl/go1.20.14.src.tar.gz
    - source_hash: sha256=1aef321a0e3e38b7e91d2d7eb64040666cabdcc77d383de3c9522d0d69b67f4e
    - require:
      - cmd: go_1.17-move
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf go1.20.14.src.tar.gz
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - file: go_1.20

go_1.20-build:
  cmd.run:
    - cwd: /opt/src/go/src
    - name: GOROOT_BOOTSTRAP=/opt/src/go1.17 ./make.bash
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: go_1.20

go_1.20-move:
  cmd.run:
    - cwd: /opt/src
    - name: mv go go1.20
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: go_1.20-build

go:
  file.managed:
    - name: /opt/src/go{{ go.version }}.src.tar.gz
    - source: https://go.dev/dl/go{{ go.version }}.src.tar.gz
    - source_hash: sha256={{ go.hash }}
    - require:
      - cmd: go_1.20-move
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf go{{ go.version }}.src.tar.gz
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - file: go

go-build:
  cmd.run:
    - cwd: /opt/src/go/src
    - name: GOROOT_BOOTSTRAP=/opt/src/go1.20 ./all.bash
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: go
