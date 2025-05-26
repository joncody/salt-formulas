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
  git.latest:
    - name: {{ go.repo }}
    - branch: release-branch.go1.4
    - rev: release-branch.go1.4
    - target: /opt/src/go_bootstrap
    - require:
      - pkg: go_bootstrap
  cmd.run:
    - cwd: /opt/src/go_bootstrap/src
    - name: GOPATH=/opt/src/go_bootstrap GOPATH=/opt/src/go_bootstrap ./make.bash
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - git: go_bootstrap

go1.17:
  git.latest:
    - name: {{ go.repo }}
    - branch: release-branch.go1.17
    - rev: release-branch.go1.17
    - target: /opt/src/go1.17
    - require:
      - cmd: go_bootstrap
  cmd.run:
    - cwd: /opt/src/go1.17/src
    - name: GOROOT_BOOTSTRAP=/opt/src/go_bootstrap GOPATH=/opt/src/go1.17 ./make.bash
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - git: go1.17

go1.20:
  git.latest:
    - name: {{ go.repo }}
    - branch: release-branch.go1.20
    - rev: release-branch.go1.20
    - target: /opt/src/go1.20
    - require:
      - cmd: go1.17
  cmd.run:
    - cwd: /opt/src/go1.20/src
    - name: GOROOT_BOOTSTRAP=/opt/src/go1.17 GOPATH=/opt/src/go1.20 ./make.bash
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - git: go1.20

go:
  git.latest:
    - name: {{ go.repo }}
    - branch: {{ go.branch }}
    - rev: {{ go.rev }}
    - target: /opt/src/go
    - require:
      - cmd: go1.20
  cmd.run:
    - cwd: /opt/src/go/src
    - name: GOROOT_BOOTSTRAP=/opt/src/go1.20 GOPATH=/opt/src/go ./make.bash
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - git: go
