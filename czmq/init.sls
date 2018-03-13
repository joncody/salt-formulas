{% from "czmq/map.jinja" import czmq with context %}

include:
  - zmq

czmq:
  pkg.installed:
    - names:
      - git
      - build-essential
      - libtool
      - pkg-config
      - autotools-dev
      - autoconf
      - automake
      - cmake
      - uuid-dev
      - libpcre3-dev
      - valgrind
      - asciidoc
      - liblz4-dev
    - require:
      - cmd: zmq
  git.latest:
    - name: {{ czmq.repo }}
    - branch: master
    - target: /opt/src/czmq
    - require:
      - pkg: czmq
  cmd.run:
    - cwd: /opt/src/czmq
    - name: ./autogen.sh && ./configure --prefix=/opt/czmq --with-gnu-ld --with-libzmq=/opt/zmq --with-uuid --with-liblz4 --with-docs && make && make install && make clean
    - unless: test -d /opt/czmq
    - require:
      - git: czmq
