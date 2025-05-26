{% from "node/map.jinja" import node with context %}

include:
  - optsrc

node:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - autotools-dev
      - build-essential
      - cmake
      - gdb
      - git
      - libevent-dev
      - libssl-dev
      - libtool
      - openssl
      - pkg-config
      - python3-all-dev
      - valgrind
      - zlib1g-dev
    - require:
      - file: optsrc
  git.latest:
    - name: {{ node.repo }}
    - branch: {{ node.branch }}
    - rev: {{ node.rev }}
    - target: /opt/src/node
    - require:
      - pkg: node
  cmd.run:
    - cwd: /opt/src/node
    - name: ./configure --prefix=/opt/node && make -j4 && make install && make clean
    - user: root
    - group: root
    - shell: /bin/bash
    - unless: test -d /opt/node
    - require:
      - git: node
