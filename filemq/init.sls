{% from "filemq/map.jinja" import filemq with context %}

include:
  - czmq

filemq:
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
    - name: {{ filemq.repo }}
    - branch: master
    - target: /opt/src/filemq
    - require:
      - pkg: filemq
  cmd.run:
    - cwd: /opt/src/filemq
    - name: ./autogen.sh && ./configure --prefix=/opt/filemq --with-gnu-ld --with-libsodium --with-libzmq --with-libczmq --with-docs && make && make install && make clean && ldconfig && source /etc/profile
    - unless: test -d /opt/filemq
    - require:
      - git: filemq
