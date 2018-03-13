{% from "zyre/map.jinja" import zyre with context %}

include:
  - czmq

zyre:
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
      - cmd: czmq
  git.latest:
    - name: {{ zyre.repo }}
    - branch: master
    - target: /opt/src/zyre
    - require:
      - pkg: zyre
  cmd.run:
    - cwd: /opt/src/zyre
    - name: ./autogen.sh && ./configure --prefix=/opt/zyre --with-gnu-ld --with-libzmq=/opt/zmq --with-libczmq=/opt/czmq --with-docs && make && make install && make clean && ldconfig && source /etc/profile
    - unless: test -d /opt/zyre
    - require:
      - git: zyre
