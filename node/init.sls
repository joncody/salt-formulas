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
      - python-all-dev
      - valgrind
      - zlib1g-dev
  git.latest;
    - name: {{ node.repo }}
    - branch: master
    - target: /opt/src/node
    - require:
      - file: optsrc
  cmd.run:
    - cwd: /opt/src/node
    - name: ./configure --prefix=/opt/node --debug --gdb && make && make install && make clean
    - unless: test -d /opt/node
    - require:
      - git: node
