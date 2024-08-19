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
  file.managed:
    - name: /opt/src/node-v{{ node.version }}.tar.gz
    - source: https://nodejs.org/dist/v{{ node.version }}/node-v{{ node.version }}.tar.gz
    - source_hash: https://nodejs.org/dist/v{{ node.version }}/SHASUMS256.txt
    - source_hash_name: node-v{{ node.version }}.tar.gz
    - require:
      - pkg: node
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf node-v{{ node.version }}.tar.gz
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - file: node

node-build:
  cmd.run:
    - cwd: /opt/src/node-v{{ node.version }}
    - name: ./configure --prefix=/opt/node --debug --gdb && make -j4 && make install && make clean
    - user: root
    - group: root
    - shell: /bin/bash
    - unless: test -d /opt/node
    - require:
      - cmd: node
