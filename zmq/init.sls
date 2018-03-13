{% from "zmq/map.jinja" import zmq with context %}

include:
  - optsrc

zmq:
  pkg.installed:
    - name:
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
      - file: optsrc
  git.latest:
    - name: {{ zmq.repo }}
    - branch: master
    - target: /opt/src/libzmq
    - require:
      - pkg: zmq
  cmd.run:
    - cwd: /opt/src/zmq
    - name: ./autogen.sh && ./configure --prefix=/opt/zmq --enable-debug --enable-valgrind --with-gnu-ld --with-libsodium --with-pgm && make && make install && make clean
    - require:
      - git: zmq
