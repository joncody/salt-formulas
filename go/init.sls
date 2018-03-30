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
    - target: /opt/src/go_bootstrap
    - require:
      - pkg: go_bootstrap
  cmd.run:
    - cwd: /opt/src/go_bootstrap/src
    - name: ./make.bash
    - require:
      - git: go_bootstrap

go:
  git.latest:
    - name: {{ go.repo }}
    - branch: master
    - target: /opt/src/go
    - require:
      - cmd: go_bootstrap
  cmd.run:
    - cwd: /opt/src/go/src
    - name: GOROOT_BOOTSTRAP=/opt/src/go_bootstrap ./all.bash
    - require:
      - git: go
